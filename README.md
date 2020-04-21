# Python wheels manylinux build - GitHub Action

![GitHub release](https://flat.badgen.net/github/release/RalfG/python-wheels-manylinux-build)
![License](https://flat.badgen.net/github/license/RalfG/python-wheels-manylinux-build)
![Open issues](https://flat.badgen.net/github/open-issues/RalfG/python-wheels-manylinux-build)
![Merged PRs](https://flat.badgen.net/github/merged-prs/RalfG/python-wheels-manylinux-build)
![GitHub Stars](https://flat.badgen.net/github/stars/RalfG/python-wheels-manylinux-build)
![GitHub Forks](https://flat.badgen.net/github/forks/RalfG/python-wheels-manylinux-build)

Build manylinux wheels for a (Cython) Python package.

This action uses the [manylinux](https://github.com/pypa/manylinux) containers to
build manylinux wheels for a (Cython) Python package. The wheels are placed in a
new directory `wheelhouse` and can be uploaded to PyPI in the next step of your
workflow.

## Usage

### Example
Minimal:

```yaml
uses: RalfG/python-wheels-manylinux-build@v0.2.2
with:
  python-versions: 'cp36-cp36m cp37-cp37m'
```

Using all arguments:

```yaml
uses: RalfG/python-wheels-manylinux-build@v0.2.2-manylinux2010_x86_64
with:
  python-versions: 'cp36-cp36m cp37-cp37m'
  build-requirements: 'cython numpy'
  system-packages: 'lrzip-devel zlib-devel'
  package-path: 'my_project'
  pip-wheel-args: '--no-deps'
```

See
[full_workflow_example.yml](https://github.com/RalfG/python-wheels-manylinux-build/blob/master/full_workflow_example.yml)
for a complete example that includes linting and uploading to PyPI.


### Inputs

| name | description | required | default | example(s) |
| - | - | - | - | - |
| `python-versions` | Python version tags for which to build (PEP 425 tags) wheels, as described in the [manylinux image documentation](https://github.com/pypa/manylinux), space-separated | required | `'cp36-cp36m cp37-cp37m cp38-cp38'` | `'cp36-cp36m cp37-cp37m'` |
| `build-requirements` | Python (pip) packages required at build time, space-separated | optional | `''` | `'cython'` or `'cython==0.29.14'` |
| `system-packages` | System (yum) packages required at build time, space-separated | optional | `''` | `'lrzip-devel zlib-devel'` |
| `package-path` | Path to python package to build (e.g. where `setup.py` file is located), relative to repository root | optional | `''` | `'my_project'` |
| `pip-wheel-args` | Extra extra arguments to pass to the `pip wheel` command (see [pip documentation](https://pip.pypa.io/en/stable/reference/pip_wheel/)) | optional | `'--no-deps'` | `'--no-deps --pre'` |
| `upload-release-asset-url` | If specified, fixed wheels are uploaded to the release url specificed here. The url should be the output of a [`@actions/create-release`](https://www.github.com/actions/create-release) action. | optional | `''` | `''` |

### Output
The action creates wheels in a new `wheelhouse` directory. Be sure to upload
only the `wheelhouse/*-manylinux*.whl` wheels, as the non-audited (e.g. `linux_x86_64`)
wheels are not accepted by PyPI.

### Using a different manylinux container
The `manylinux2010_x86_64` container is used by default. To use another manylinux
container, append `-<container-name>` to the reference. For example:
`RalfG/python-wheels-manylinux-build@v0.2.2-manylinux2014_aarch64` instead of
`RalfG/python-wheels-manylinux-build@v0.2.2`.

## Contributing
Bugs, questions or suggestions? Feel free to post an issue in the
[issue tracker](https://github.com/RalfG/python-wheels-manylinux-build/issues)
or to make a pull request!
