import type { Config } from "tailwindcss";
const config: Config = { darkMode: "class", content: ["./app/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}"], theme: { extend: { colors: { ink: "#111111", beige: "#E8DCCF", gold: "#C9A227" }, boxShadow: { luxe: "0 16px 45px rgba(17,17,17,.10)" }, fontFamily: { display: ["Georgia", "serif"] } } }, plugins: [] };
export default config;
