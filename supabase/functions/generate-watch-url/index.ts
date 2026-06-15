import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

//EDGE FUNCTION
//generate-watch-url

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {

    if (req.method === "OPTIONS") {
        return new Response("ok", { headers: corsHeaders });
    }

  try {
    
    // 1. Leer API key desde Supabase Secrets
    const apiKey = Deno.env.get("TMDB_API_KEY");

    if (!apiKey) {
      return new Response(
        JSON.stringify({ error: "Missing TMDB API key" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 2. Parsear body enviado desde Flutter
    const body = await req.json();

    const {
      path,        // /discover/movie?...
      page = 1,
    } = body;

    if (!path) {
      return new Response(
        JSON.stringify({ error: "Missing path" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 3. Construir URL base TMDB
    const baseUrl = `https://api.themoviedb.org/3${path}`;

    // 4. Añadir api_key y page de forma segura
    const url = baseUrl.includes("?")
      ? `${baseUrl}&api_key=${apiKey}&page=${page}`
      : `${baseUrl}?api_key=${apiKey}&page=${page}`;

    // 5. Llamada a TMDB
    const response = await fetch(url);

    if (!response.ok) {
      return new Response(
        JSON.stringify({
          error: "TMDB request failed",
          status: response.status,
        }),
        { status: 502, headers: {  ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const data = await response.json();

    // 6. Devolver datos al cliente Flutter
    return new Response(JSON.stringify(data), {
      status: 200,
      headers: {
        ...corsHeaders,
        "Content-Type": "application/json",

        // (opcional) cache básico para evitar spam a TMDB
        "Cache-Control": "public, max-age=60",
      },
    });

  } catch (error) {
    // Convertimos el error a un tipo seguro para leer su mensaje
    const errorMessage = error instanceof Error ? error.message : 'Error desconocido'

    return new Response(JSON.stringify({ error: errorMessage }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })

  }
});