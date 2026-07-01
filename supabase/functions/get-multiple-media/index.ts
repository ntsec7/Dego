//EDGE FUNCTION
//get-multiple-media

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });

  try {
    const apiKey = Deno.env.get("TMDB_API_KEY");
    if (!apiKey) {
      return new Response(JSON.stringify({ error: "Falta TMDB API key" }), { status: 500, headers: corsHeaders });
    }

    const { ids, tipo = 'movie' } = await req.json();

    if (!ids || !Array.isArray(ids) || ids.length === 0) {
      return new Response(JSON.stringify({ error: "Error en el array de Ids" }), { status: 400, headers: corsHeaders });
    }

    // HACEMOS LAS PETICIONES EN PARALELO DESDE EL SERVIDOR
    // Mapeamos cada ID a una promesa fetch independiente
    const promesas = ids.map(async (id) => {
      const url = `https://api.themoviedb.org/3/${tipo}/${id}?api_key=${apiKey}&language=es-ES`;
      try {
        const res = await fetch(url);
        if (res.ok) {
          return await res.json();
        }
        return null; // Si una peli falla, devolvemos null para no romper el resto
      } catch {
        return null;
      }
    });

    // Esperamos a que terminen todas las peticiones simultáneamente
    const resultadosCrudos = await Promise.all(promesas);
    
    // Filtramos los posibles nulos por si algún ID falló en TMDB y transformamos 'genres' en 'genre_ids'
    const resultadosValidos = resultadosCrudos
      .filter(item => item !== null)
      .map(item => {
        // Si TMDB nos devolvió el objeto 'genres', extraemos solo los IDs
        if (item.genres && Array.isArray(item.genres)) {
          item.genre_ids = item.genres.map((g: { id: number }) => g.id);
        }
        return item;
      });

    // Devolvemos DIRECTAMENTE una lista JSON al cliente de Flutter
    return new Response(JSON.stringify(resultadosValidos), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });

  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'Error desconocido';
    return new Response(JSON.stringify({ error: errorMessage }), { status: 500, headers: corsHeaders });
  }
});