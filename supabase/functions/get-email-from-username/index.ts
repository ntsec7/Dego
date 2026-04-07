import { serve } from "https://deno.land/std@0.177.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

//get-email-from-username
serve(async (req) => {

  // Manejo de CORS para que Flutter pueda conectar
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Access-Control-Allow-Methods': 'POST, OPTIONS'
  }

  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  let body

  try{

    try {
      body = await req.json()
    } catch {
      return new Response(JSON.stringify({ error: 'Body inválido' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      })
    }

    const { username } = body

    //Admin
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    let user= username

    const { data,  error: dbError } = await supabaseAdmin
      .rpc('get_email_from_username', { input_username: user })

      const email = data ?? null

      if (dbError || !email) {
        return new Response(JSON.stringify({ error: 'Credenciales incorrectas' }), { 
          status: 400, 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        })
      }

      return new Response(JSON.stringify({ email: email }), {
        status: 200,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      })


  } catch (e) {
    console.error("ERROR:", e)
    return new Response(JSON.stringify({ error: 'Error interno del servidor' }), { status: 500 })
  }

})