import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

//EDGE FUNCTION
//get-movie-serie-detail

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

    // 2. Parsear el body enviado desde Flutter
    const body = await req.json();
    const { id, isMovie } = body;

    if (!id) {
      return new Response(
        JSON.stringify({ error: "Missing media ID" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 3. Determinar el segmento del path según el tipo de contenido
    const mediaType = isMovie ? "movie" : "tv";

    // 4. Construir la URL 
    const url = `https://api.themoviedb.org/3/${mediaType}/${id}?api_key=${apiKey}&language=es-ES&append_to_response=credits,videos,watch/providers,recommendations&include_video_language=es,en,null`;

    // 5. Llamada a TMDB
    const response = await fetch(url);

    if (!response.ok) {
      return new Response(
        JSON.stringify({ error: "TMDB request failed", status: response.status }),
        { status: 502, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const data = await response.json();

    // 6. Enviar el JSON completo a Flutter
    return new Response(JSON.stringify(data), {
      status: 200,
      headers: {
        ...corsHeaders,
        "Content-Type": "application/json",
        "Cache-Control": "public, max-age=300", // 5 minutos de caché 
      },
    });

  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'Error desconocido';
    return new Response(JSON.stringify({ error: errorMessage }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }
});