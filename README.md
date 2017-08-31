# jekyll-inline-svg

SVG optimizer and inliner for jekyll

This liquid tag will let you inline SVG images in your jekyll sites. It will add `{%svg %}` to `Liquid::Tag`.

## Installation

Run `gem install jekyll-inline-svg` or add `gem "jekyll-inline-svg", "~>0.0.1"` to your **Gemfile**.

Then in your **_config.yml** :

```
gems:
  - jekyll-inline-svg
```

Optimization is opt-in and can be enabled by adding this to your `_config.yml`

```
svg:
  optimize: true
```

## Usage

Use the Liquid tag in your pages :

```
    {% svg /path/to/square.svg width=24 foo="bar" %}
```

Jekyll will include the svg file in your output HTML like this :

```
<svg width=24 foo="bar" version="1.1" id="square" xmlns="http://www.w3.org/2000/svg" x="0" y="0" viewBox="0 0 24 24" >
  <rect width="20" height="20" x="2" y="2" />
</svg>
```

**Note** : You will generally want to set the width/height of your SVG or a `style` attribute, but anything can be passed through.

Paths with a space should be quoted :

```
{% svg "/path/to/foo bar.svg" %}
# or :
{% svg '/path/to/foo bar.svg' %}
```
Otherwise anything after the first space will be considered an attribute.

Liquid variables will be interpreted if enclosed in double brackets :

```
{% assign size=40 %}
{% svg "/path/to/{{site.foo-name}}.svg" width="{{size}}" %}
```
`height` is automatically set to match `width` if omitted. It can't be left unset because IE11 won't use the viewport attribute to calculate the image's aspect ratio.



Relative paths and absolute paths will both be interpreted from Jekyll's configured [source directory](https://jekyllrb.com/docs/configuration/). So both :

```
    {% svg "/path/to/foo.svg" %}
    {% svg "path/to/foo.svg"  %}
```

Should resolve to `/your/site/source/path/to/foo.svg`. As jekyll prevents you from getting out of the source dir, `/../drawing.svg` will also resolve to `./drawing.svg`.


## Safety

In [safe mode](https://jekyllrb.com/docs/plugins/) (ie. on github pages), the plugin will be disabled as it's not yet trusted. However it should be "safe" as defined by [Jekyll](https://jekyllrb.com/docs/plugins/) (ie. no arbitrary code execution).

Some processing is done to remove useless data :

- metadata
- comments
- unused groups
- Other filters from [svg_optimizer](https://github.com/fnando/svg_optimizer)
- default size

If any important data gets removed, or the output SVG looks different from input, it's a bug. Please file an issue to this repository describing your problem.

It does not perform any input validation on attributes. They will be appended as-is to the root node.

## Motivations

This has been creeated specifically to display svg icons in html pages.

PNG/BMP sprites are clearly a no go in a world where "a screen" can be anything from 4" to 150", ranging from 480p to 4k. So what are our vector alternatives?
Font-icons are [bad](https://cloudfour.com/thinks/seriously-dont-use-icon-fonts/). While **xlink** looks like an ideal solution, with an elegant : `<use xlink:href="/path/to/icons.svg#play"></use>`, it's badly supported in IE (up to ie11). And embedding SVGs in an `<img>` is not going to cut it. Inlined SVG icons, in my opinion, is the best option we got right now. It's also where the industry seems to be going, with big actors like [github](https://github.com/blog/2112-delivering-octicons-with-svg) starting to transition from font-icons to inlined SVG.
