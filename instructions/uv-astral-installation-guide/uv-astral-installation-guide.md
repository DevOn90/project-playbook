# UV Astral Installation Guide

## Purpose
This guide provides step-by-step instructions for installing UV Astral. UV Astral is an extremely fast Python package and project manager, written in Rust.

## Prerequisites
- `curl` installed on your system.
- `Python` installed on your system.

## Steps

1. Open a terminal window.

2. Run the following command to download and install UV Astral:

   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```
3. Add UV to system path
    ```bash
    source ~/.local/bin/env
    ```
4. Verify the installation by running the following command:

   ```bash
   uv --version
   ```

You should see the version of UV Astral printed in the terminal.