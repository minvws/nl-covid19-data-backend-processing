# **HOW TO BUILD AND RELEASE IMPLEMENTATIONS**

---

One **Github Action workflow** is used to build and register a optional self hosted runner within the `Github Container Registry` (i.e. *GHCR*) scripts. The release pipeline will automatically be trigger the **[Dockerfile](Dockerfile)**, **[entrypoint.sh](entrypoint.sh)**, **[supervisord.conf](supervisord.conf)** and the **[workflow](workflows/actions-runner-image-ci.yml)** itself.
