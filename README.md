# tsukuba-gc-lite
A script to generate garbage collection calendar which is formatted json in Tsukuba City. This is a alternative of [tsukuba-gc](https://github.com/NKMR6194/tsukuba-gc).

If you need only calender, it is available on [dist/](./dist).


## Requirement

- Ruby (>= 2.2)


## Usage

```
ruby gc-lite.rb [seed] [dest]
```

- `seed`: Location of seed file. Examples of seed file are avairable on [seed/](./seed)
- `dest`: Output json to `dest`. If `dest` are omitted, gc-lite.rb prints result to stdout.
