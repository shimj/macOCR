## OCR for macOS

#### Compile and run

```
swiftc ocr.swift -o ocr
./ocr [option]
```
Language can be specified in `[option]` with "en", "zh" (中文), "zh-Hans" (简体中文) or "zh-Hant" (繁体中文).

#### Run without compiling

```
swift ocr.swift [option]
```

#### Note

In the repository I forked from, a specified language is appended **behind** "en-US", which leads to an unexpected result.
