import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Produces a minimal, self-contained server in .next/standalone —
  // exactly what you want to COPY into a Docker image (no full node_modules needed).
  output: "standalone",
};

export default nextConfig;
