name: Test run

on:
  push:
    branches:
      - master

jobs:
  release:
    runs-on: windows-latest

    steps:
    - name: Checkout source
      uses: actions/checkout@v2
    - name: Run script
      run: ./windows.ps1