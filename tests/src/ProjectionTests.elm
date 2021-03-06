port module ProjectionTests exposing (elmToJS)

import Browser
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Json.Encode
import VegaLite exposing (..)



{- Some relevant data sources:

   https://github.com/deldersveld/topojson
   https://github.com/topojson/world-atlas

   graticule.json produced with mapshaper.org:
     open console and type -graticule then export as topojson.
-}


worldMapTemplate : String -> List ProjectionProperty -> ( String, Spec )
worldMapTemplate tText projProps =
    ( tText
    , toVegaLite
        [ width 500
        , height 300
        , title tText []
        , background "#c1e7f5"
        , projection projProps

        --, dataFromUrl "https://vega.github.io/vega-lite/data/world-110m.json" [ topojsonFeature "countries" ]
        , dataFromUrl "https://vega.github.io/vega-lite/data/graticule.json" [ topojsonFeature "graticule" ]
        , geoshape [ maFillOpacity 0.01, maStroke "#411", maStrokeWidth 0.5 ]
        ]
    )


standardProjs : List ( String, Spec )
standardProjs =
    [ worldMapTemplate "Albers" [ prType albers ]
    , worldMapTemplate "AzimuthalEqualArea" [ prType azimuthalEqualArea ]
    , worldMapTemplate "AzimuthalEquidistant" [ prType azimuthalEquidistant ]
    , worldMapTemplate "ConicConformal" [ prType conicConformal, prClipAngle (Just 65) ]
    , worldMapTemplate "ConicEqualArea" [ prType conicEqualArea ]
    , worldMapTemplate "ConicEquidistant" [ prType conicEquidistant ]
    , worldMapTemplate "EqualEarth" [ prType equalEarth ]
    , worldMapTemplate "Equirectangular" [ prType equirectangular ]
    , worldMapTemplate "Gnomonic" [ prType gnomonic ]
    , worldMapTemplate "Identity" [ prType identityProjection ]
    , worldMapTemplate "Mercator" [ prType mercator ]
    , worldMapTemplate "NaturalEarth1" [ prType naturalEarth1 ]
    , worldMapTemplate "Orthographic" [ prType orthographic ]
    , worldMapTemplate "Stereographic" [ prType stereographic ]
    , worldMapTemplate "TransverseMercator" [ prType transverseMercator ]
    ]


d3Projections : List ( String, Spec )
d3Projections =
    -- Note these require registering via JavaScript in the hosting page.
    let
        customSpec pText =
            worldMapTemplate pText [ prType (customProjection pText), prClipAngle (Just 179.999), prRotate 20 -90 0, prPrecision 0.1 ]
    in
    List.map customSpec [ "airy", "aitoff", "armadillo", "august", "baker", "berghaus", "bertin1953", "boggs", "bonne", "bottomley", "collignon", "craig", "craster", "cylindricalequalarea", "cylindricalstereographic", "eckert1", "eckert2", "eckert3", "eckert4", "eckert5", "eckert6", "eisenlohr", "fahey", "foucaut", "gingery", "winkel3" ]


configExample : ( String, Spec )
configExample =
    let
        cfg =
            configure
                << configuration (coBackground "rgb(251,247,238)")
                << configuration (coTitle [ ticoFont "Roboto", ticoFontWeight W600, ticoFontSize 18 ])
                << configuration (coView [ vicoContinuousWidth 500, vicoContinuousHeight 300, vicoStroke Nothing ])
                << configuration (coAutosize [ asFit ])
                << configuration (coProjection [ prType orthographic, prRotate 0 0 0 ])

        globeSpec =
            asSpec
                [ dataFromUrl "data/globe.json" [ topojsonFeature "globe" ]
                , geoshape [ maColor "#c1e7f5" ]
                ]

        graticuleSpec =
            asSpec
                [ dataFromUrl "https://vega.github.io/vega-lite/data/graticule.json" [ topojsonFeature "graticule" ]
                , geoshape [ maFillOpacity 0.01, maStroke "#411", maStrokeWidth 0.1 ]
                ]

        countrySpec =
            asSpec
                [ dataFromUrl "https://vega.github.io/vega-lite/data/world-110m.json" [ topojsonFeature "countries" ]
                , geoshape [ maColor "#708E71" ]
                ]
    in
    ( "configExample"
    , toVegaLite [ title "Hello, World!" [], cfg [], layer [ globeSpec, graticuleSpec, countrySpec ] ]
    )


reflectExample : Bool -> Bool -> ( String, Spec )
reflectExample rx ry =
    let
        name =
            if Basics.not rx && Basics.not ry then
                "identityExample"

            else
                "reflect"
                    ++ (if rx then
                            "X"

                        else
                            ""
                       )
                    ++ (if ry then
                            "Y"

                        else
                            ""
                       )
                    ++ "Example"

        globeSpec =
            asSpec
                [ dataFromUrl "data/globe.json" [ topojsonFeature "globe" ]
                , geoshape [ maColor "#c1e7f5" ]
                , projection [ prType identityProjection, prReflectX rx, prReflectY ry ]
                ]

        graticuleSpec =
            asSpec
                [ dataFromUrl "https://vega.github.io/vega-lite/data/graticule.json" [ topojsonFeature "graticule" ]
                , geoshape [ maFillOpacity 0.01, maStroke "#411", maStrokeWidth 0.1 ]
                , projection [ prType identityProjection, prReflectX rx, prReflectY ry ]
                ]

        countrySpec =
            asSpec
                [ dataFromUrl "https://vega.github.io/vega-lite/data/world-110m.json" [ topojsonFeature "countries" ]
                , geoshape [ maColor "#708E71" ]
                , projection [ prType identityProjection, prReflectX rx, prReflectY ry ]
                ]
    in
    ( name, toVegaLite [ width 500, height 250, layer [ globeSpec, graticuleSpec, countrySpec ] ] )



{- Ids and specifications to be provided to the Vega-Lite runtime. -}


specs : List ( String, Spec )
specs =
    standardProjs
        ++ [ configExample
           , reflectExample False False
           , reflectExample True False
           , reflectExample False True
           , reflectExample True True
           ]
        ++ d3Projections



{- ---------------------------------------------------------------------------
   BOILERPLATE: NO NEED TO EDIT

   The code below creates an Elm module that opens an outgoing port to Javascript
   and sends both the specs and DOM node to it.
   It allows the source code of any of the generated specs to be selected from
   a drop-down list. Useful for viewin specs that might generate invalid Vega-Lite.
-}


type Msg
    = NewSource String
    | NoSource


main : Program () Spec Msg
main =
    Browser.element
        { init = always ( Json.Encode.null, specs |> combineSpecs |> elmToJS )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


view : Spec -> Html Msg
view spec =
    Html.div []
        [ Html.select [ Html.Events.onInput NewSource ]
            (( "Select source", Json.Encode.null )
                :: specs
                |> List.map (\( s, _ ) -> Html.option [ Html.Attributes.value s ] [ Html.text s ])
            )
        , Html.div [ Html.Attributes.id "specSource" ] []
        , if spec == Json.Encode.null then
            Html.div [] []

          else
            Html.pre [] [ Html.text (Json.Encode.encode 2 spec) ]
        ]


update : Msg -> Spec -> ( Spec, Cmd Msg )
update msg model =
    case msg of
        NewSource srcName ->
            ( specs |> Dict.fromList |> Dict.get srcName |> Maybe.withDefault Json.Encode.null, Cmd.none )

        NoSource ->
            ( Json.Encode.null, Cmd.none )


port elmToJS : Spec -> Cmd msg
