import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

//EDGE FUNCTION
//update-user

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      { auth: { persistSession: false } }
    )

    //Verificar la identidad del que llama a la función
    const authHeader = req.headers.get('Authorization')!
    const token = authHeader.replace('Bearer ', '')
    const { data: { user: requester }, error: authError } = await supabaseAdmin.auth.getUser(token)
    
    if (authError || !requester) {
      return new Response(JSON.stringify({ error: 'No autorizado' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    // Verificar si es Administrador
     const { data: profile } = await supabaseAdmin
      .from('usuario')
      .select('user_type')
      .eq('id', requester.id)
      .single()

    if (profile?.user_type !== 'admin') {
      return new Response(JSON.stringify({ error: 'Prohibido: Solo los administradores pueden editar usuarios' }), {
        status: 403,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    //Obtener los datos del body (parámetros opcionales)
    const { userIdToUpdate, newEmail, newPassword } = await req.json()

    if (!userIdToUpdate) {
      return new Response(JSON.stringify({ error: 'Falta el userIdToUpdate' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    //Construir el objeto con los campos que se van a actualizar dinámicamente
    const updateData: Record<string, string | boolean> = {}
    if (newEmail) updateData.email = newEmail
    if (newPassword) updateData.password = newPassword
    
    // Si no enviaron ni email ni contraseña, devolvemos un error
    if (Object.keys(updateData).length === 0) {
      return new Response(JSON.stringify({ error: 'Debes proporcionar al menos un campo para actualizar (newEmail o newPassword)' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    // Adicionalmente, confirmamos el email automáticamente para que el usuario modificado no quede "pendiente de verificación"
    // if (newEmail) {
    //   updateData.email_confirm = true
    // }

    //Ejecutar la actualización en auth.users usando la API de administración
    const { data: updatedUser, error: updateError } = await supabaseAdmin.auth.admin.updateUserById(
      userIdToUpdate,
      updateData
    )

    if (updateError) throw updateError

    return new Response(JSON.stringify({ message: 'Usuario actualizado con éxito', user: updatedUser }), {
      status: 200,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })

  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'Error desconocido'
    return new Response(JSON.stringify({ error: errorMessage }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})