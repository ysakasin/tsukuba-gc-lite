# tsukuba-gc-lite
A script to generate garbage collection calendar which is formatted json in Tsukuba City. This is a alternative of [tsukuba-gc](https://github.com/NKMR6194/tsukuba-gc).

If you need only calender, it is available on [dist/](./dist).

**Caution**: This is unofficial. Official information is available on ["Tsukuba City Calendar for Putting Out Garbage"](http://www.city.tsukuba.ibaraki.jp/14211/14244/001115.html).


## Requirement

- Ruby (>= 2.2)
- [icalendar gem](https://rubygems.org/gems/icalendar/)


## Usage

```
ruby gc-lite.rb [format] [seed] [dest]
```

- `format`: Select format of output. `json` or `ics`
- `seed`: Location of seed file. Examples of seed file are avairable on [seed/](./seed)
- `dest`: Output json to `dest`. If `dest` are omitted, gc-lite.rb prints result to stdout.
