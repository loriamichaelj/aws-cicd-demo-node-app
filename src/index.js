import process from "node:process";

import dayjs from "dayjs";

const APP_NAME = "node-app";

export function describeBuild() {
  return {
    app: APP_NAME,
    gitSha: process.env.GIT_SHA ?? "unknown",
    environment: process.env.APP_ENVIRONMENT ?? "unknown",
    nodeVersion: process.versions.node,
    builtAt: dayjs().toISOString(),
  };
}

function log(message) {
  console.log(`${dayjs().toISOString()} INFO ${APP_NAME} ${message}`);
}

function main() {
  log("build fixture starting");
  log(JSON.stringify(describeBuild()));
  log("no service to run in this phase; exiting cleanly");
  return 0;
}

process.exitCode = main();
