# An *unofficial* meta repository of OpenCilk

## Structure

```
https://github.com/OpenCilk/opencilk-project → opencilk-project
https://github.com/OpenCilk/cheetah → opencilk-project/cheetah
https://github.com/OpenCilk/productivity-tools → opencilk-project/cilktools
```

OpenCilk's build system and structure sadly has some oddities:
- The 'cheetah' repository is placed in the 'opencilk-project' repository, overriding an existing directory (which is part of the 'opencilk-project' repository).
- The 'producitivity-tools' repository is placed under a different name 'cilktools' in 'opencilk-project'

We currently also backport a LLVM patch to allow this to be build on "modern" Linuxes: https://reviews.llvm.org/rG68d5235cb58f988c71b403334cd9482d663841ab
