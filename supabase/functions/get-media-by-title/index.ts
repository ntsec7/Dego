import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

//EDGE FUNCTION
//get-media-by-title

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

type TMDBResult = {
    title?: string;
    name?: string;
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const apiKey = Deno.env.get("TMDB_API_KEY");

    if (!apiKey) {
      throw new Error("Falta API Key de TMDB");
    }

    const { title, type } = await req.json();

    if (!title || !type) {
      return new Response(
        JSON.stringify({
          error: "Falta el título o tipo",
        }),
        {
          status: 400,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    const endpoint =
      type === "film"
        ? "movie"
        : "tv";

    const url =
      `https://api.themoviedb.org/3/search/${endpoint}` +
      `?api_key=${apiKey}` +
      `&query=${encodeURIComponent(title)}` +
      `&language=es-ES`;

    const response = await fetch(url);

    if (!response.ok) {
      throw new Error("La petición TMDB falló");
    }

    const data = await response.json();

    if (!data.results || data.results.length === 0) {
      return new Response(
        JSON.stringify(null),
        {
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    const results = data.results as TMDBResult[];

    // const normalize = (text: string) =>
    // text
    //     .toLowerCase()
    //     .trim()
    //     .replace(/\s+/g, " ");

    // const normalizedTitle = normalize(title);

    // const exact = results.find((item) => {
    // const name = normalize(item.title ?? item.name ?? "");
    // return name === normalizedTitle;
    // });

    // const result = exact ?? results[0];
    const result = results[0];

    return new Response(JSON.stringify(result),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );

  } catch (error) {
    return new Response(
      JSON.stringify({
        error: error instanceof Error
          ? error.message
          : "Error desconocido",
      }),
      {
        status: 500,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  }
});