import { expect, test } from "vitest";
import { render, screen } from "@testing-library/react";
import Page from "./page";

test("home page renders the main heading", () => {
  render(<Page />);

  const heading = screen.getByRole("heading", { level: 1 });
  expect(heading.textContent).toContain("CI CD By Hamza Mughal");
});
