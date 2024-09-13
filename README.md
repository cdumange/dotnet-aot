# .NET AOT

## Goal

The goal of this repository is to do some basic tests around the new .NET AOT compilation options.

For that, we're going to be taking a simple webapi template and make it work both as classic interpretation and AOT compilation.


## Results

|Compilation type|Docker Build Time (s)| Publish Time (s)| Image size (Mo) | Ram usage|
|------|---|---|-----|-----|
|standard|11|4|110|54|
|aot|52|35|30|19|

From a compilation standpoint, it's a success. All metrics are lower except for build time (which is pretty logical). The source of this augmentation are :

- publish time: the application is built Ahead Of Time so it's pretty logical that the publish phase is a lot longer.
- dependencies: the publish phase needs a few librairies to be able to build the executable. Their installation in the build step takes a few seconds.

### Code wise

The real surprise to this simple test is the implication for the test. As you can see, a few modification have had to be done around the JSON serialization.

Indeed, in an interpretation context, the CLR is able to generate the serialization code automatically. In the AOT context, we have to specify the JsonContext to enable the serialization of our records.

## Conclusion

If it's technicaly interesting, the limitation around code generation are too strong to allow a common usage of AOT for .NET complex application. It could still be interesting for other usecases like CLIs but I feel other language are far more interesting in those contexts (Go, Rust, ...).

