import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

//EDGE FUNCTION
//delete-user

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Manejo de peticiones CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Inicializar cliente de Supabase con la Service Role Key (para tener permisos de Admin)
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      { auth: { persistSession: false } }
    )

    // Obtener el usuario que está llamando a la función a partir de su JWT
    const authHeader = req.headers.get('Authorization')!
    const token = authHeader.replace('Bearer ', '')
    
    const { data: { user: requester }, error: authError } = await supabaseAdmin.auth.getUser(token)
    
    if (authError || !requester) {
      return new Response(JSON.stringify({ error: 'No autorizado' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    // Obtener el ID del usuario que se desea eliminar (desde el body del POST)
    const { userIdToDelete } = await req.json()

    if (!userIdToDelete) {
      return new Response(JSON.stringify({ error: 'Falta el userIdToDelete' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    // Se intenta eliminar a si mismo
    const isSelf = requester.id === userIdToDelete
    

    // Verificamos el rol desde BD
    const { data: profile } = await supabaseAdmin
      .from('usuario')
      .select('user_type')
      .eq('id', requester.id)
      .single()
    const isAdmin = profile?.user_type === 'admin'

    if (!isSelf && !isAdmin) {
      return new Response(JSON.stringify({ error: 'No tienes permisos para eliminar a este usuario' }), {
        status: 403,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    // Eliminar en auth.users. Con el ON DELETE CASCADE se elimina de todos sitios
    const { error: deleteError } = await supabaseAdmin.auth.admin.deleteUser(userIdToDelete)

    if (deleteError) {
      throw deleteError
    }

    return new Response(JSON.stringify({ message: `Usuario ${userIdToDelete} eliminado con éxito` }), {
      status: 200,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })

  } catch (error) {
    // Convertimos el error a un tipo seguro para leer su mensaje
    const errorMessage = error instanceof Error ? error.message : 'Error desconocido'

    return new Response(JSON.stringify({ error: errorMessage }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})