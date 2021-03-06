# Vega Lite Changes

# Pending changes

## Breaking Changes

- `axTickCount` and `axcoTickCount` now take a `ScaleNice` parameter rather than `Float` so that time intervals may be supplied. Previous code that used `axTickCount 123` should now use `axTickCount (niTickCount 123)` (VL.4.10).

* New position channels `Theta`, `Theta2`, `R` and `R2` for radial positioning (e.g. pie charts). This is technically a breaking change as they are new variants in the exposed `Position` type, although in practice this won't break any existing specifications unless pattern matching against all `Position` variants (VL4.9).

- `hdTitleFontWeight` now correctly uses a `FontWeight` parameter (`Bold`, `W300` etc.) rather than a string. The string version inadvertently slipped through in earlier versions. Any specifications that use a String for the weight can use the equivalent `FontWeight` variant.

* `rgExtent` and `dnExtent` now take two floats as the extent values rather than `DataValue` types. To update previous code replace `(num x0) (num x1)` with `x0 x1` where `x0` and `x1` are the minimum and maximum numeric values of the extent.

- `key` now creates a field/type object. Previously this incorrectly generated a string rather than object, so while this is a breaking change, there should be no working specs with the old key type. Field name can be specified with `kName` and type with `kQuant`, `kNominal` etc.

## Additions

- `coCustomFormatTypes` for enabling/disabling use of registered custom formatters (VL4.11).

* `axcoDisable` and `lecoDisable` to disable axes and legends by default in configuration (VL4.10).

- `mBand` for non-positional band encoding (VL4.10)

* `arc` and `text` mark offset functions `maThetaOffset`, `maTheta2Offset`, `maRadiusOffset` and `maRadius2Offset` (VL4.10).

- `pDatum` for specifying a literal data-driven positioning (VL.4.9).

* `mDatum` for specifying a literal data-driven mark property (VL.4.9).

- `layerFields` and `arLayer` for arranging views in layers using a repeat list of fields (VL4.9).

* `mRepeatDatum` for specifying a set of literal datum values in a repeated view (VL4.9).

- `angle` channel for data-driven rotation of point and text symbols (VL4.9).

* `arc` mark and associated radial mark properties `maInnerRadius`, `maOuterRadius`, `maTheta` and `maTheta2` (VL4.9).

- `maRadiusOffset` for polar offsetting of text marks that have been positioned via `Theta` and `R` (VL 4.9).

* `leTitleOrient` for positioning a title relative to legend content.

### Bug Fixes

- `niInterval` now correctly generates a time unit string rather than `"unit":XXX`.

### Other Changes

- Calling `dataFromRows` or `dataFromColumns` without `dataRow` / `dataColumn` now generates an empty dataset that can be useful for creating annotation layers with literals.
- Minor improvements to the API documentation.
- Additions to tests for new VL4.9 and VL4.10 features.
- New gallery examples.

---

## V2.2.0 ➡ V2.3.0

### Additions

- `hdLabelBaseline`, `hdLabelExpr`, `hdLabelFontStyle`, `hdLabelFontWeight`, `hdLabelLineHeight`, `hdLabels`, `hdOrient`, `hdTitleFontStyle` and `hdTitleLineHeight` facet header customisation options (VL 4.8).

* `coAxisXFilter` and `coAxisYFilter` to modify axis configurations to apply only to the X or Y axes (supports changes in VL 4.7)

- `maBlend` and associated `bm` blend mode options for specifying how overlaid colours are combined (VL 4.6).

* `vaLineTop` and `vaLineBottom` for vertical alignment of text marks based on line height (VL 4.6).

- `axLabelLineHeight` and `axcoLabelLineHeight` for setting axis label line height (VL 4.6).

* `opProduct` for aggregation of numeric values by their product (VL 4.6).

- `axFormatAsCustom`, `leFormatAsCustom`, `hdFormatAsCustom` and `tFormatAsCustom` for using registered text formatters (VL 4.6).

* `axTickDash` and `cAxTickDash` for conditional tick dash styles (VL 4.6)

- `cAxLabelOffset` for conditional axis label offsetting (VL 4.5)

* `coAxisDiscrete` and `coAxisPoint` axis configuration options (VL 4.5)

- `sacoXReverse` for configuring right-to-left charts and undeprecated `scReverse` (VL 4.5)

* `axcoLabelExpr` and `axcoTickCount` for configuring default label transformations and tick counts (VL 4.4)

- `axLabelOffset` for offsetting axis labels from their tick marks (VL 4.4).

* `axStyle` and `coAxisStyles` for named style configuration of axis properties (VL 4.4).

- `coMarkStyles` in place of previous `coNamedStyles` for greater naming consistency.

- `tiLineHeight` for setting title line height

* `doSelectionChannel` and `doSelectionField` for projecting selection onto a specific field or channel when scaling a domain.

### Deprecations

- `coNamedStyle` and `coNamedStyles` both deprecated in favour of `coMarkStyles`. Provides greater naming consistency with the addition of (VL 4.4) `coAxisStyles`.

* `coAxisX` and `coAxisY` deprecated in favour of the more flexible `coAxisXFilter` and `coAxisYFilter` modifiers. For example, replace `coAxisX [ axcoTitleColor "red" ]` with `coAxis [ axcoTitleColor "red" ] |> coAxisXFilter)`

- `scBinLinear` deprecated in favour of `scLinear` with binning aggregation.

### Other Changes

- `maText` now respects multi-line strings.

* Simplified Likert gallery example to use multi-line text literals.

- Providing `hdTitle` with an empty string now generates a JSON null value rather than empty string, to be compatible with schema.

* Replaced now deprecated `coNamedStyle` and `coNamedStyles` with `coMarkStyles` in gallery examples and test.

---

## V2.1.0 ➡ V2.2.0

### Additions

- `doUnionWith` for combining fixed and data-driven domains (VL 4.3)
- `coFont` for configuring global font (VL 4.3).
- `strokeDash` and associated `chStrokeDash` encoding channel (VL 4.2)
- `coAxisQuant` and `coAxisTemporal` for configuring quantitative and temporal axes (VL 4.2)
- `timeUnit` can now create objects parameterised with `tuMAxBins` and `tuStep` (VL 4.1).
- `maCornerRadiusEnd` for rounding upper or right corners of bar rectangles (V L4.1).
- `scDomainMid` for setting midpoint in a diverging continuous scale (VL 4.1).
- `cAxLabelPadding` and `cAxTickSize` conditional axis formatting (VL 4.1)
- `smCursor` for setting cursor over selection mark (VL 4.1)
- `vicoCursor` for setting default cursor over view.
- `miLinearClosed` interpolation to form closed polygons (missed exposing this from earlier releases).
- `fAlign`, `fCenter` and `fSpacing` for positioning of sub-plots in faceted views (VL 4).
- `lecoUnselectedOpacity` for setting opacity of unselected interactive legend items (VL 4).
- `ticoLineHeight`, `axcoTitleLineHeight`, `lecoTitleLineHeight` and `maLineHeight` for multi-line text line height configuration (VL 4).
- `vaAlphabetic` for baseline vertical alignment of text marks.
- `maLimit`, `maEllipsis` and `maDir` with `tdLeftToRight` and `tdRightToLeft` for truncating and formatting text marks.
- providing empty lists to the boxplot elements that appear by default (outliers, median, box and rule) now removes them.
- `\n` in a `tStr` string literal now respects multiple-lines in text mark.

### Other Changes

- Minor corrections to the API documentation.
- Internal refactor of transform functions that return multiple labelled specs.
- Additions to tests for new VL4.1 features
- Amended examples and tests to conform with the (breaking) changes in the VL4.1 schema.

---

## V2.0.0 ➡ V2.1.0

### Additions

- `naturalEarth1` map projection type.

### Bug Fixes

- Correct `maxsteps` parameter output of `density` transform (thanks @dougburke for spotting this).

* Correct but in `density` that was incorrectly using value of `dnCounts` for the `dnCumulative` setting (thanks @dougburke for spotting this).

---

## V1.12 ➡ V2.0

Major release supporting Vega-Lite 4.0. Includes a small number of breaking changes that should provide greater flexibility and some simplification of the API.

### Breaking Changes

- _`title` now takes a list of optional title properties._
  To update older code, simply add a `[]` as a second parameter to `title`

* _`lookup` now allows naming of individual matched fields and a default for failed lookups_.
  Instead of `lookup "key1" secondaryData "key2" ["field1", "field2"]` use `lookup "key1" secondaryData "key2" (luFields ["field1", "field2"])`. Additional functions `luAs`, `luAsWithDefault`, `luFieldsAs`, `luFieldsAsWithDefault`, `luFields` and `luFieldsWithDefault` provide greater flexibility in naming and default behaviour. It also uses the `Data` type alias as part of its type signature, which is unlikely to impact any use of the API but is technically a breaking change.

- _Replaced `coRemoveInvalid` with `maRemoveInvalid`_.
  To stop filtering of invalid values, this is now specified as a mark property. For example, instead of `configuration (coRemoveInvalid False)`, use `configuration (coMark [ maRemoveInvalid False ])`.

* _Tooltips are now disabled by default_ (via change in Vega-lite).
  Can be enabled either via an explicit `tooltip` channel, or by setting `maTooltip ttEncoding`.

- _Background is now white by default_ (via a change in Vega-lite).
  Previously backgrounds were transparent. Can mimic previous behaviour by adding a transparent configuration `configuration (coBackground "rgba(0,0,0,0)")`

* _`axValues` now takes `DataValues` (allowing numbers, strings, dates and Booleans) rather than just a list of floats._
  To update older code, replace `axValues [1,2,3] with axValues (nums [1,2,3])`.

- _Removed (invalid) functions `mImpute` and `dImpute`._

* _`opArgMin` and `opArgMax` now require a `Maybe String` parameter._
  To update older code, replace `opArgMin` with `opArgMin Nothing`.

- _Overlap strategy constructors hidden._
  Should use `osNone`, `osGreedy` and `osParity` instead. These were always available, but the constructors themselves had been inadvertently exposed, so it is unlikely to require a change in practice.

* _`columns` now takes an `int` rather than `Maybe int`._
  To update older code, replace `columns (Just n)` with `columns n` and `columns Nothing` with `columns 0`.

- `Position` custom type has extra variants `XError`, `XError2`, `YError` and `YError2`. Technically a breaking change but unlikely to affect existing specifications unless pattern matching against `Position`.

### Additions

#### Transforms

- `density` (and associated `dn` density property functions) for KDE transforms.

* `loess` (and associated `ls` loess property functions) for locally-estimated scatterplot smoothing.

- `pivot` (and associated `pi` pivot property functions) for data shaping.

* `quantile` (and associated `qt` quantile property functions) for computing quantiles from a distribution.

- `regression` (and associated `rg` regression property functions) for regression modelling.

* `fiOp` for converting filters into `BooleanOp` and therefore allowing Boolean composition of filter functions.

- `fiOpTrans` for combining an inline data transformation with a filter and converting to a `BooleanOp`. Especially useful when filtering temporal data that require aggregating with `mTimeUnit`.

#### Marks and Mark Properties

- `image` mark and associated `url` channel and `maAspect` mark property for displaying images.

* `mSort` for sorting by mark properties like `color`.

- `maColorGradient`, `maFillGradient` and `maStrokeGradient` (and associated `gr` gradient property functions) for gradient-based colouring.

* `maCornerRadius`, `maCornerRadiusBottomLeft`, `maCornerRadiusBottomRight`, `maCornerRadiusTopLeft` and `maCornerRadiusTopRight` for rounding a rectangle mark.

- `maWidth` and `maHeight` for explicitly setting mark width and height.

* `pBand` for setting position/size relative to a band width.

- Support empty strings for `maFill` and `maStroke` to indicate absence of fill or stroke.

#### Selections

- `lookupSelection` for lookups that rely on an interactive selection of data.

* `seBindLegend` and associated property functions `blField`, `blChannel` and `blEvent` for creating interactive legends.

- `seInitInterval` for initialising an interval selection's extent.

* `biSelectionExtent` for basing a bin extent on an interactive selection.

#### Configuration

- New title configuration options: `ticoFontStyle`, `ticoFrame`, `ticoStyle`, `ticoZIndex`, `ticoSubtitleColor`, `ticoSubtitleFont`, `ticoSubtitleFontSize`, `ticoSubtitleFontStyle`, `ticoSubtitleFontWeight`, `ticoSubtitleLineHeight` and `ticoSubtitlePadding`.

* `coConcat` for configuring concatenations (`cocoSpacing` and `cocoColumns`).

- `vicoStep` for configuring default step size for discrete x and y discrete fields.

* `vicoContinuousWidth`, `vicoDiscreteWidth`, `vicoContinuousHeight` and `vicoDiscreteHeight` for dimension configuration depending on type of data.

- `vicoBackground` for configuring default single view plot area background appearance.

#### Titles and Axes

- `title` and component titles (axis title, legend title etc.) can now be formatted over multiple lines with `\n` or `"""` multi-line strings.

* `axDataCondition` and associated `cAx` property functions for conditional axis formatting.

- Additional axis formatting options: `axGridColor`, `axGridOpacity`, `axGridWidth`, `axLabelExpr`, `axLabelFontStyle`, `axLabelSeparation`, `axTitleFontStyle` and `axTitleAnchor` along with extra config options `axcoLabelFontStyle`, `axcoLabelSeparation`, `axcoTitleFontStyle` and `axcoTitleAnchor`.

* New title option `tiSubtitle` for specifying secondary title text. Can be styled via new functions `tiSubtitleColor`, `tiSubtitleFont`, `tiSubtitleFontSize`, `tiSubtitleFontStyle`, `tiSubtitleFontWeight`, `tiSubtitleLineHeight` and `tiSubtitlePadding`.

#### Data

- `noData` for preventing inheritance of parent data source in a specification.

* `nullValue` for explicitly setting data values to null.

- `dtMonthNum` for referencing a month by its numeric value.

* `tStr` for string literals in a text encoding channel.

#### Other

- Convenience functions for setting a channel's measurement type. `pNominal`, `pOrdinal`, `pQuant`, `pTemporal` and `pGeo` equivalent to `pMType Nominal`, `pMType Ordinal` etc. Similar functions for `m` (mark), `t` (text), `h` (hyperlink), `o` (order) `d` (detail) and `f` (facet) channels.

* `scAlign` for aligning marks within a range.

- `widthStep` and `heightStep` for setting the width/height of a discrete x or y field (e.g. individual bars in a bar chart).

* `widthOfContainer` and `heightOfContainer` for responsive sizing.

- `asFitX` and `asFitY` for autosizing in one dimension only.

* Additional symbols `symTriangleLeft`, `symTriangleRight`, `symTriangle`, `symArrow`, `symWedge` and `symStroke` and `mSymbol` convenience function for symbol literals.

- `equalEarth` map projection type.

* `key` channel for binding with Vega View API.

### Deprecations

- `axcoShortTimeLabels` deprecated as this is the default since VL4.

* `axDates` deprecated in favour of new more flexible `axValues`.

- `lookupAs` deprecated in favour of `lookup` with `luAs`.

* `scReverse` deprecated in favour of `mSort` (while `scReverse` works, it is not part of the Vega-Lite schema).

- `scRangeStep`, deprecated in favour of `widthStep` and `heightStep`.

* `sacoRangeStep` and `sacoTextXRangeStep` deprecated in favour of `vicoStep`.

- `vicoWidth` and `vicoHeight` deprecated in favour of `vicoContinuousWidth`, `vicoDiscreteWidth`, `vicoContinuousHeight` and `vicoDiscreteHeight`.

* `coStack` deprecated as it is unecessary.

### Bug Fixes

- `coFieldTitle` now correctly creates a 'functional' label.

* Overlap strategy `osNone` now evaluates correctly.

- Field definitions inside `mDataCondition` now handled correctly (previously only worked with value definitions).

* Empty grid/stroke dash list now correctly generates a `null` value rather than empty array in JSON spec (while an empty array works, it is not permitted by the Vega-Lite schema).

### Other Changes

- Improvements to the API documentation with a larger number of inline examples.

* New gallery examples reflecting additions to the Vega-Lite example set.

- Numerous minor gallery example updates to reflect API changes and provide more idiomatic specifications.

* Additional tests for new functionality.
