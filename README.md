# aws-cicd-demo-node-app

A Node.js containerization fixture that consumes
[aws-cicd-framework](https://github.com/loriamichaelj/aws-cicd-framework).

This repository carries **no functional application logic, by design**. It exists to give
the framework's build, lint, and containerization steps a real artifact to operate on.

`main` is the default branch and holds only this README — an entry point and signpost,
not the deliverable. The actual Dockerfile, source, tests, and pipeline caller live on the
`dev`/`stage`/`prod` branches.

## Branches

| Branch | Contents |
| --- | --- |
| `main` | This README only. Entry point, signpost, and GitHub default branch. |
| `dev` | Active development. Push here auto-deploys to the `dev` environment. |
| `stage` | PR-merge here deploys to the `stage` environment, behind a required reviewer. |
| `prod` | PR-merge here deploys to the `prod` environment, behind a required reviewer. |

**➡ [Browse the current code on the `dev` branch](https://github.com/loriamichaelj/aws-cicd-demo-node-app/tree/dev)**

## Documentation

See [aws-cicd-framework](https://github.com/loriamichaelj/aws-cicd-framework) for the
pipeline this repository consumes, including `docs/REQUIREMENTS.md` and `docs/DESIGN.md`.
