// import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

// //EDGE FUNCTION
// //get-multiple-media

// const corsHeaders = {
//   'Access-Control-Allow-Origin': '*',
//   'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
// }

// serve(async (req) => {
//   if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });

//   try {
//     const apiKey = Deno.env.get("TMDB_API_KEY");
//     if (!apiKey) {
//       return new Response(JSON.stringify({ error: "Falta TMDB API key" }), { status: 500, headers: corsHeaders });
//     }

//     const { ids, tipo = 'movie' } = await req.json(); // ids es un Array de números [550, 299534...]

//     if (!ids || !Array.isArray(ids) || ids.length === 0) {
//       return new Response(JSON.stringify({ error: "Error en el array de Ids" }), { status: 400, headers: corsHeaders });
//     }

//     // Como máximo procesamos 20 por petición por limitaciones de TMDB
//     const idsToProcess = ids.slice(0, 20);
//     const idPrincipal = idsToProcess[0];
//     const extras = idsToProcess.slice(1).map(id => `${tipo}/${id}`).join(',');

//     const url = `https://api.themoviedb.org/3/${tipo}/${idPrincipal}?api_key=${apiKey}&language=es-ES&append_to_response=${extras}`;


//     console.log("URL solicitada a TMDB:", url);
//     const response = await fetch(url);
//     if (!response.ok) {
//       return new Response(JSON.stringify({ error: "TMDB falló" }), { status: 502, headers: corsHeaders });
//     }

//     const data = await response.json();
//     return new Response(JSON.stringify(data), {
//       status: 200,
//       headers: { ...corsHeaders, "Content-Type": "application/json" },
//     });

//   } catch (error) {
//     const errorMessage = error instanceof Error ? error.message : 'Error desconocido';
//     return new Response(JSON.stringify({ error: errorMessage }), { status: 500, headers: corsHeaders });
//   }
// });

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

    // 🔄 HACEMOS LAS PETICIONES EN PARALELO DESDE EL SERVIDOR
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
    
    // Filtramos los posibles nulos por si algún ID falló en TMDB
    const resultadosValidos = resultadosCrudos.filter(item => item !== null);

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