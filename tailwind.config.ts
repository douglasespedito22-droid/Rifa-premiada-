import type { Config } from "tailwindcss";
const config: Config = {
  content: ["./src/**/*.{js,ts,jsx,tsx,mdx}"],
  theme: {
    extend: {
      colors: {
        navy: { 950: "#07152f", 900: "#0b1f44", 800: "#12366e", 700: "#174ea6" },
        skybrand: "#4da3ff",
        mint: "#65e6c1"
      },
      boxShadow: { glow: "0 18px 60px rgba(36, 99, 235, .18)" }
    }
  },
  plugins: []
};
export default config;
