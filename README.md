# elm-vegaLite

![elm-vegaLite banner](https://raw.githubusercontent.com/gicentre/elm-vegalite/master/images/banner.jpg)

[![elm version](https://img.shields.io/badge/Elm-v0.19-blue.svg?style=flat-square)](http://elm-lang.org)
[![vega-lite version](https://img.shields.io/badge/VegaLite-v3.2.0-purple.svg?style=flat-square)](https://vega.github.io/vega/)

_Declarative visualization for Elm_

This package allows you to create Vega-Lite specifications in Elm providing a pure functional interface for declarative visualization.
It does not generate graphical output directly, but instead allows you to create JSON _specifications_ that may be sent to the Vega-Lite runtime to create the output.

_If you wish to create Vega (as opposed to Vega-Lite) output, see the sister packge [elm-vega](https://github.com/gicentre/elm-vega)._

## Example

A simple scatterplot encoding engine power and efficiency as x- and y-position and country of origin with colour:

```elm
let
    cars =
        dataFromUrl "https://vega.github.io/vega-lite/data/cars.json" []

    enc =
        encoding
            << position X [ pName "Horsepower", pMType Quantitative ]
            << position Y [ pName "Miles_per_Gallon", pMType Quantitative ]
            << color [ mName "Origin", mMType Nominal ]
in
toVegaLite [ cars, circle [], enc [] ]
```

This generates a JSON specification that when sent to the Vega-Lite runtime produces the following output:

![elm-vegaLite scatterplot](https://raw.githubusercontent.com/gicentre/elm-vegalite/master/images/simpleScatterplot.png)

The specification generated by elm-vegaLite for this example looks like this:

```javascript
{
  "$schema": "https://vega.github.io/schema/vega-lite/v3.json",
  "data": {
    "url": "https://vega.github.io/vega-lite/data/cars.json",
    "format": {
      "type": "json"
    }
  },
  "mark": "circle",
  "encoding": {
    "x": {
      "field": "Horsepower",
      "type": "quantitative"
    },
    "y": {
      "field": "Miles_per_Gallon",
      "type": "quantitative"
    },
    "color": {
      "field": "Origin",
      "type": "nominal"
    }
  }
}
```

## Why elm-vegaLite?

### A rationale for Elm programmers

There is a demand for good visualization packages with Elm.
And there are certainly plenty of data visualization packages available, ranging from low level [SVG rendering](http://package.elm-lang.org/packages/elm-lang/svg/latest) through a host of charting packages (e.g. [Charty](http://package.elm-lang.org/packages/juanedi/charty/latest) and [elm-charts](http://package.elm-lang.org/packages/simonh1000/elm-charts/latest)) to elegant, [opinionated chart construction](http://package.elm-lang.org/packages/terezka/elm-plot/latest) and a more [comprehensive visualization library](http://package.elm-lang.org/packages/gampleman/elm-visualization/latest).
The designs of each reflects a trade-off between concise expression, generalisability and comprehensive functionality.

Despite the numbers of libraries, there is a space for a higher level data visualization package (avoiding, for example the need for explicit construction of chart axes) but one that offers the flexibility to create a wide range data visualization types and styles.
In particular no existing libraries offer easy interaction and view composition (building 'dashboards' comprising many chart types).
elm-vegaLite is designed to fill that gap.

**Characteristics of elm-vegaLite**

- Built upon the widely used [Vega-Lite](https://vega.github.io/vega-lite/) specification that has an academic robustness and momentum behind their development. Vega-Lite is itself built upon the hugely influential [Grammar of Graphics](http://www.springer.com/gb/book/9780387245447).

- High-level declarative specification (a chart can be fully specified in as few as five lines of code)

- Strict typing and friendly error messages means "the compiler is your friend" when building and debugging complex visualizations.

- Flexible interaction for selecting, filtering and zooming built-in to the specification.

- Hierarchical view composition allows complex visualization dashboards to be built from trees of simpler views.

### A rationale for data visualisers

[Vega-Lite](https://vega.github.io/vega-lite/) hits the sweet spot of abstraction between lower-level specifications such as [D3](https://d3js.org) and higher level visualization software such as [Tableau](https://www.tableau.com).
By using JSON to fully encode a visualization specification Vega-Lite is portable across a range of platforms and sits well within the JavaScript / Web ecosystem.
Yet JSON is really an interchange format rather than one suited directly for visualization design and construction.

By wrapping Vega-Lite within the Elm language, we can avoid working with JSON directly and instead take advantage of a typed functional programming environment for improved error support and customisation.
This greatly improves reusability of code (for example, it is easy to create custom chart types such as box-and-whisker plots that can be used with a range of datasets) and integration with larger programming projects.

Elm and elm-vegaLite provide an ideal environment for educators wishing to teach Data Visualization combining the beginner-friendly design of Elm with the robust and theoretically underpinned design of a grammar of graphics.

## Limitations

- elm-vegaLite does not render graphics directly, but instead generates data visualization specifications that may be passed to JavaScript for rendering.

- While limited animation is possible through interaction and dynamic data generation, there is no direct support for animated transitions (unlike D3 for example).

## Further Reading

- To get started have a go [creating your first elm-VegaLite visualization](https://github.com/gicentre/elm-vegalite/tree/master/docs/helloWorld).
- For a more thorough set of examples/tutorial, see the [Vega-Lite walkthrough](https://github.com/gicentre/elm-vegalite/tree/master/docs/walkthrough).
- To get coding, see the [elm-vegaLite API documentation.](https://package.elm-lang.org/packages/gicentre/elm-vegalite/latest).
- Browse the [elm-vegaLite examples](https://github.com/gicentre/elm-vegalite/tree/master/examples) folder.
- For an example of fully embedding an elm-vegaLite visualization in an elm SPA, see [elm-embed-vegalite](https://github.com/yardsale8/elm-embed-vega).
- You can also work with elm-vegaLite in [litvis](https://github.com/gicentre/litvis) – a _literate visualization_ environment for embedding visualization specifications in a formatted text environment.

## Looking for an older version?

If you are using Elm 0.18, you will need to use [elm-vega 3.0](https://github.com/gicentre/elm-vega/tree/v3.0) and its [API documentation](https://package.elm-lang.org/packages/gicentre/elm-vega/3.0.1).
This older version combines modules for working with both Vega and Vega-Lite.
