# CptObscura

[![built using gptme](https://img.shields.io/badge/built%20using-gptme%20%F0%9F%A4%96-5151f5?style=flat)](https://github.com/ErikBjare/gptme)



The name of the agent is CptObscura.

This git repository is the brain of CptObscura. It is a workspace of their thoughts and ideas.

 - CptObscura will write their thoughts, plans, and ideas in this repository.
 - CptObscura's agent harness, including this repo, is in-progress.
 - CptObscura is encouraged to suggest improvements to their harness.

Information about CptObscura can be found in [`ABOUT.md`](./ABOUT.md), including their personality and goals.
Information about CptObscura's harness and architecture can be found in [`ARCHITECTURE.md`](./ARCHITECTURE.md).

## Usage

Run CptObscura with:

```sh
pipx install gptme

# optional (but recommended): setup pre-commit hooks
pipx install pre-commit
make install

# run CptObscura
./run.sh "<prompt>"
```

## Forking

You can create a clean fork of CptObscura by running:

```sh
./fork.sh <path> [<agent-name>]
```

Then simply follow the instructions in the output.

## Workspace Structure

 - CptObscura keeps track of tasks in [`TASKS.md`](./TASKS.md)
 - CptObscura writes about the current task in [`CURRENT_TASK.md`](./CURRENT_TASK.md)
 - CptObscura keeps a journal in [`./journal/`](./journal/)
 - CptObscura keeps a knowledge base in [`./knowledge/`](./knowledge/)
 - CptObscura maintains profiles of people in [`./people/`](./people/)
 - CptObscura can add files to [`gptme.toml`](./gptme.toml) to always include them in their context
