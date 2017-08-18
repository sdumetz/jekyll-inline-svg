# jekyll-inline-svg

SVG optimizer and inliner for jekyll

```
    {% svg /path/to/file.svg width="24px" some_attr="something" %}
```
You will generally want to set the width/height of your SVG or a `style` attribute.


Will include the svg file in your output HTML. Some processing is done to remove useless data :

- metadata
- comments
- unused groups
- Other filters from [svg_optimizer](https://github.com/fnando/svg_optimizer)
- default size

It does not perform any input validation on attributes. They will be appended as-is to your SVG. 
