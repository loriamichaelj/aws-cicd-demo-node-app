# aws-cicd-demo-node-app

A Node.js containerization fixture that consumes
[aws-cicd-framework](https://github.com/loriamichaelj/aws-cicd-framework).

This repository carries **no functional application logic, by design**. It exists to give
the framework's build, lint, and containerization steps a real artifact to operate on. It
does not bind a port, serve traffic, or need to run in order to be considered complete.
The engineering on display is the Dockerfile and the pipeline that consumes it.

AWS resources built from this repository use the logical app name **`node-app`** —
deliberately decoupled from the GitHub repository name, which carries the `aws-cicd-`
prefix only for grouping on GitHub.

## Layout

```
src/index.js                   no-op entrypoint; prints a build descriptor and exits 0
test/index.test.js             unit test exercising describeBuild()
package.json                   one real dependency (dayjs), ESM, Node 20
package-lock.json              committed lockfile; the image builds with npm ci
Dockerfile                     multi-stage, non-root, healthchecked
.dockerignore                  keeps VCS metadata and node_modules out of the build context
.github/workflows/deploy.yml   thin caller: push-to-dev triggers aws-cicd-framework's deploy.yml
```

## Dockerfile discipline

The framework enforces a `hadolint` step that fails the pipeline on any error-level
finding. This Dockerfile is written against that bar:

| Requirement | How it is met |
| --- | --- |
| Multi-stage build | `builder` resolves `node_modules`; `runtime` copies only the result |
| Non-root with explicit UID | dedicated `app` user, `USER 10001` |
| Pinned base image | `node:20-alpine`, never `:latest` |
| Pinned dependencies | `package-lock.json` committed; `npm ci --omit=dev` |
| No build tooling in final image | dev dependencies omitted, install scripts disabled |
| Dependency install before source copy | manifest and lockfile copied and installed before `src/` |
| Healthcheck present | `HEALTHCHECK` parsing the entrypoint |
| OCI labels present | `org.opencontainers.image.*` on the runtime stage |
| No secrets in any layer | nothing sensitive enters the build context |

`npm ci --ignore-scripts` is deliberate: lifecycle scripts from transitive dependencies are
a well-worn supply-chain vector, and nothing here needs them.

## Local checks

These are the same commands the pipeline runs, so failures reproduce locally:

```bash
node --check src/index.js
npm test
docker build -t node-app:local .
docker run --rm node-app:local
hadolint Dockerfile
```

## Branches

`main` is the default and holds the deliverable. `dev` is where work happens.

`stage` and `prod` exist as **GitHub Environments**, not branches. Promotion to them is a
manually dispatched workflow that copies the already-built artifact forward behind an
approval gate — the image is never rebuilt per environment, so the image digest referenced
in `prod` is provably identical to the one built on `dev`.
