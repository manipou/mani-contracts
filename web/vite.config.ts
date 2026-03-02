import { defineConfig } from "vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";
// import tailwindcss from "@tailwindcss/postcss";
import Icons from "unplugin-icons/vite";
import postcssPresetEnv from "postcss-preset-env";
import tailwindcss from "@tailwindcss/vite";

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    tailwindcss(),
    svelte(),
    Icons({
      compiler: "svelte",
      autoInstall: true,
    }),
  ],
  css: {
    postcss: {
      plugins: [postcssPresetEnv({})],
    },
  },
  base: "./",
  build: {
    outDir: "./build",
    emptyOutDir: true,
  },
  resolve: {
    alias: {
      $lib: "/src/lib",
      src: "/src",
      "@": "/src",
      "@components": "/src/lib/components",
      "@utilities": "/src/lib/utils",
    },
  },
});
