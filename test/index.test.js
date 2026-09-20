import test from "node:test";
import assert from "node:assert/strict";

import { describeBuild } from "../src/index.js";

test("describeBuild returns expected shape", () => {
  const info = describeBuild();
  assert.equal(info.app, "node-app");
  assert.ok(info.nodeVersion);
});
