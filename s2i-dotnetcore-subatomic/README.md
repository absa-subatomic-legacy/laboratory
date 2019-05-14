# Subatomic .Net Core S2I image

This S2I image is based off the [Red Hat .NET Core S2I image](https://github.com/redhat-developer/s2i-dotnetcore).



Environment variables
---------------------

To set these environment variables, you can place them as a key value pair into
a `.s2i/environment` file inside your source code repository.

* **DOTNET_STARTUP_PROJECT**

    Used to select the project to run. This must be a project file (e.g. csproj, fsproj) or a folder containing a single project file. Defaults to `.`.

* **DOTNET_ASSEMBLY_NAME**

    Used to select the assembly to run. This must NOT include the `.dll` extension.
    Set this to the output assembly name specified in the project file (`PropertyGroup/AssemblyName`). This defaults
    to the project filename.

* **DOTNET_RESTORE_SOURCES**

    Used to specify the list of NuGet package sources used during the restore operation. This overrides 
    all of the sources specified in the NuGet.config file.

* **DOTNET_RESTORE_DISABLE_PARALLEL**

    When set to true disables restoring multiple projects in parallel. This reduces restore timeout errors when the build container is running with low cpu limits. 
    Defaults to `false`.

* **DOTNET_TOOLS**

    Used to specify a list of .NET tools to install before building the app. It is possible to install a specific version by postpending
    the package name with `@<version>`. Defaults to ``.

* **DOTNET_NPM_TOOLS**

    Used to specify a list of npm packages to install before building the app.
    Defaults to ``.

* **DOTNET_TEST_PROJECTS**

    Used to specify the list of test projects to run. This must be project files or folders containing a
    single project file. `dotnet test` is invoked for each item. Defaults to ``.

* **DOTNET_VERBOSITY**

    Used to specify the verbosity of the dotnet build commands. When set, the environment variables are printed at the start
    of the build. This variable can be set to one of the msbuild verbosity values (`q[uiet]`, `m[inimal]`, `n[ormal]`,
    `d[etailed]`, and `diag[nostic]`). Defaults to ``.

* **DOTNET_CONFIGURATION**

    Used to run the application in Debug or Release mode. This should be either
    `Release` or `Debug`.  This is passed to the `dotnet publish` invocation.
    Defaults to `Release`.

* **ASPNETCORE_URLS**

    This variable is set to `http://*:8080` to configure ASP.NET Core to use the
    port exposed by the image.

* **HTTP_PROXY, HTTPS_PROXY**

    Configures the HTTP/HTTPS proxy used when building and running the application.

* **DOTNET_RM_SRC**

    When set to `true`, the source code will not be included in the image. Defaults to ``.

* **DOTNET_INCREMENTAL**

    When set to `true`, the NuGet packages will be kept so they can be re-used for an incremental build.
    Defaults to `false`.

* **NPM_MIRROR**

    Use a custom NPM registry mirror to download packages during the build process.

* **DOTNET_STARTUP_ASSEMBLY**

    Used to specify the path of the entrypoint assembly within the source repository. When set,
    the source repository must contain a pre-built application. Defaults to ``.

* **DOTNET_PACK**

    When set to `true` creates a tar.gz file at `/opt/app-root/app.tar.gz` that contains the published application.

* **DEV_MODE**

    When set to `true`, the application restart automatically when the source code changes. `dotnet run`
    is used to start the application.

* **DOTNET_USE_POLLING_FILE_WATCHER**

    This is set to `true` to ensure the `dotnet watch` command works in a container. This command is not used by the default scripts.


NPM
---

Typical modern web applications rely on javascript tools to build the front-end.
The image includes npm (node package manager) to install these tools. Packages can be
installed by setting `DOTNET_NPM_TOOLS` and by calling `npm install` in the build process.
