port module ConditionalTests exposing (elmToJS)

import Browser
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Json.Encode
import VegaLite exposing (..)


markCondition1 : Spec
markCondition1 =
    let
        data =
            dataFromUrl "https://vega.github.io/vega-lite/data/movies.json" []

        cfg =
            configure
                << configuration (coMark [ maRemoveInvalid False ])

        enc =
            encoding
                << position X [ pName "IMDB_Rating", pQuant ]
                << position Y [ pName "Rotten_Tomatoes_Rating", pQuant ]
                << color
                    [ mDataCondition
                        [ ( or (expr "datum.IMDB_Rating === null")
                                (expr "datum.Rotten_Tomatoes_Rating === null")
                          , [ mStr "#ddd" ]
                          )
                        ]
                        [ mStr "#0099ee" ]
                    ]
    in
    toVegaLite [ cfg [], data, point [], enc [] ]


markCondition2 : Spec
markCondition2 =
    let
        data =
            dataFromColumns []
                << dataColumn "value" (nums [ 10, 20, 30, 40, 50, 60 ])

        enc =
            encoding
                << position X [ pName "value", pOrdinal ]
                << color
                    [ mDataCondition
                        [ ( expr "datum.value < 40", [ mStr "blue" ] )
                        , ( expr "datum.value < 50", [ mStr "red" ] )
                        , ( expr "datum.value < 60", [ mStr "yellow" ] )
                        ]
                        [ mStr "black" ]
                    ]
    in
    toVegaLite [ width 400, data [], circle [ maSize 800 ], enc [] ]


axisCondition1 : Spec
axisCondition1 =
    let
        data =
            dataFromUrl "https://vega.github.io/vega-lite/data/movies.json" []

        enc =
            encoding
                << position X
                    [ pName "IMDB_Rating"
                    , pQuant
                    , pAxis
                        [ axTickCount (niTickCount 20)
                        , axDataCondition (expr "datum.value <= 5") (cAxGridDash [ 2, 2 ] [])
                        ]
                    ]
                << position Y [ pName "Rotten_Tomatoes_Rating", pQuant ]
    in
    toVegaLite [ data, point [ maOpacity 0.1 ], enc [] ]


axisCondition2 : Spec
axisCondition2 =
    let
        data =
            dataFromUrl "https://vega.github.io/vega-lite/data/movies.json" []

        enc =
            encoding
                << position X
                    [ pName "IMDB_Rating"
                    , pQuant
                    , pAxis
                        [ axTickCount (niTickCount 20)
                        , axDataCondition (expr "datum.value <= 2") (cAxTickColor "red" "blue")
                        , axDataCondition (expr "datum.value >=5") (cAxTickSize 12 6)
                        , axDataCondition (expr "datum.value >=8") (cAxTickOpacity 0.3 0.8)
                        , axDataCondition (expr "datum.label =='4.0'") (cAxTickWidth 5 2)
                        ]
                    ]
                << position Y
                    [ pName "Rotten_Tomatoes_Rating"
                    , pQuant
                    , pAxis [ axDataCondition (expr "datum.value <= 99") (cAxLabelPadding 12 8) ]
                    ]
    in
    toVegaLite [ width 600, data, point [ maOpacity 0.1 ], enc [] ]


axisCondition3 : Spec
axisCondition3 =
    let
        data =
            dataFromUrl "https://vega.github.io/vega-lite/data/movies.json" []

        enc =
            encoding
                << position X
                    [ pName "IMDB_Rating"
                    , pQuant
                    , pAxis
                        [ axTickCount (niTickCount 20)
                        , axDataCondition (expr "datum.value <= 1") (cAxLabelAlign haRight haLeft)
                        , axDataCondition (expr "datum.value <= 2") (cAxLabelColor "red" "blue")
                        , axDataCondition (expr "datum.value <= 3") (cAxLabelBaseline vaTop vaBottom)
                        , axDataCondition (expr "datum.value <= 4") (cAxLabelFont "serif" "sans-serif")
                        , axDataCondition (expr "datum.value <= 6") (cAxLabelFontSize 12 18)
                        , axDataCondition (expr "datum.value <=8") (cAxLabelFontStyle "normal" "italic")
                        , axDataCondition (expr "datum.label =='4.0'") (cAxLabelFontWeight Bold W100)
                        , axDataCondition (expr "datum.value >=9") (cAxLabelOpacity 0.3 0.8)
                        ]
                    ]
                << position Y [ pName "Rotten_Tomatoes_Rating", pQuant ]
    in
    toVegaLite [ width 600, data, point [ maOpacity 0.1 ], enc [] ]


selectionCondition1 : Spec
selectionCondition1 =
    let
        data =
            dataFromUrl "https://vega.github.io/vega-lite/data/cars.json" []

        sel =
            selection
                << select "alex"
                    seInterval
                    [ seOn "[mousedown[!event.shiftKey], mouseup] > mousemove"
                    , seTranslate "[mousedown[!event.shiftKey], mouseup] > mousemove"
                    ]
                << select "morgan"
                    seInterval
                    [ seOn "[mousedown[event.shiftKey], mouseup] > mousemove"
                    , seTranslate "[mousedown[event.shiftKey], mouseup] > mousemove"
                    , seSelectionMark [ smFill "#fdbb84", smFillOpacity 0.5, smStroke "#e34a33" ]
                    ]

        enc =
            encoding
                << position Y [ pName "Origin", pOrdinal ]
                << position X [ pName "Cylinders", pOrdinal ]
                << color [ mAggregate opCount, mName "*", mQuant ]
    in
    toVegaLite
        [ data, sel [], rect [ maCursor cuGrab ], enc [] ]


selectionCondition2 : Spec
selectionCondition2 =
    let
        data =
            dataFromUrl "https://vega.github.io/vega-lite/data/cars.json" []

        sel =
            selection
                << select "alex"
                    seInterval
                    [ seOn "[mousedown[!event.shiftKey], mouseup] > mousemove"
                    , seTranslate "[mousedown[!event.shiftKey], mouseup] > mousemove"
                    ]
                << select "morgan"
                    seInterval
                    [ seOn "[mousedown[event.shiftKey], mouseup] > mousemove"
                    , seTranslate "[mousedown[event.shiftKey], mouseup] > mousemove"
                    , seSelectionMark [ smFill "#fdbb84", smFillOpacity 0.5, smStroke "#e34a33" ]
                    ]

        enc =
            encoding
                << position Y [ pName "Origin", pOrdinal ]
                << position X [ pName "Cylinders", pOrdinal ]
                << color
                    [ mSelectionCondition
                        (and (selectionName "alex") (selectionName "morgan"))
                        [ mAggregate opCount, mName "*", mQuant ]
                        [ mStr "gray" ]
                    ]
    in
    toVegaLite
        [ data, sel [], rect [ maCursor cuGrab ], enc [] ]


selectionCondition3 : Spec
selectionCondition3 =
    let
        data =
            dataFromUrl "https://vega.github.io/vega-lite/data/cars.json" []

        trans =
            transform
                << filter
                    (fiCompose
                        (and (selected "brush")
                            (expr "datum.Weight_in_lbs > 3000")
                        )
                    )

        sel =
            selection
                << select "brush" seInterval []

        enc1 =
            encoding
                << position X [ pName "Horsepower", pQuant ]
                << position Y [ pName "Miles_per_Gallon", pQuant ]

        spec1 =
            asSpec [ sel [], point [], enc1 [] ]

        enc2 =
            encoding
                << position X [ pName "Acceleration", pQuant, pScale [ scDomain (doNums [ 0, 25 ]) ] ]
                << position Y [ pName "Displacement", pQuant, pScale [ scDomain (doNums [ 0, 500 ]) ] ]

        spec2 =
            asSpec [ trans [], point [], enc2 [] ]
    in
    toVegaLite
        [ data, vConcat [ spec1, spec2 ] ]


selectionCondition4 : Spec
selectionCondition4 =
    let
        data =
            dataFromUrl "https://vega.github.io/vega-lite/data/cars.json" []

        sel =
            selection
                << select "mySelection"
                    seInterval
                    [ seClear ""
                    , seOn "[mousedown[!event.shiftKey], mouseup] > mousemove"
                    , seTranslate "[mousedown[!event.shiftKey], mouseup] > mousemove"
                    ]

        enc =
            encoding
                << position Y [ pName "Origin", pOrdinal ]
                << position X [ pName "Cylinders", pOrdinal ]
                << color
                    [ mSelectionCondition
                        (selectionName "mySelection")
                        [ mAggregate opCount, mName "*", mQuant ]
                        [ mStr "gray" ]
                    ]
    in
    toVegaLite
        [ data, sel [], rect [ maCursor cuGrab ], enc [] ]


selectionCondition5 : Spec
selectionCondition5 =
    let
        data =
            dataFromUrl "https://vega.github.io/vega-lite/data/cars.json" []

        sel =
            selection
                << select "mySelection"
                    seInterval
                    [ seClear "mouseup"
                    , seEmpty
                    , seOn "[mousedown[!event.shiftKey], mouseup] > mousemove"
                    , seTranslate "[mousedown[!event.shiftKey], mouseup] > mousemove"
                    ]

        enc =
            encoding
                << position Y [ pName "Origin", pOrdinal ]
                << position X [ pName "Cylinders", pOrdinal ]
                << color
                    [ mSelectionCondition
                        (selectionName "mySelection")
                        [ mAggregate opCount, mName "*", mQuant ]
                        [ mStr "gray" ]
                    ]
    in
    toVegaLite
        [ data, sel [], rect [ maCursor cuGrab ], enc [] ]


bindScales1 : Spec
bindScales1 =
    let
        data =
            dataFromUrl "https://vega.github.io/vega-lite/data/cars.json"

        sel =
            selection
                << select "myZoomPan" seInterval [ seBindScales ]

        enc =
            encoding
                << position X [ pName "Horsepower", pQuant ]
                << position Y [ pName "Miles_per_Gallon", pQuant ]
    in
    toVegaLite
        [ width 300, height 300, data [], sel [], circle [], enc [] ]


bindScales2 : Spec
bindScales2 =
    let
        data =
            dataFromUrl "https://vega.github.io/vega-lite/data/cars.json"

        sel =
            selection
                << select "myZoomPan"
                    seInterval
                    [ seBindScales, seClear "click[event.shiftKey]" ]

        enc =
            encoding
                << position X [ pName "Horsepower", pQuant ]
                << position Y [ pName "Miles_per_Gallon", pQuant ]
    in
    toVegaLite
        [ width 300, height 300, data [], sel [], circle [], enc [] ]



{- Ids and specifications to be provided to the Vega-Lite runtime. -}


specs : List ( String, Spec )
specs =
    [ ( "markCondition1", markCondition1 )
    , ( "markCondition2", markCondition2 )
    , ( "axisCondition1", axisCondition1 )
    , ( "axisCondition2", axisCondition2 )
    , ( "axisCondition3", axisCondition3 )
    , ( "selectionCondition1", selectionCondition1 )
    , ( "selectionCondition2", selectionCondition2 )
    , ( "selectionCondition3", selectionCondition3 )
    , ( "selectionCondition4", selectionCondition4 )
    , ( "selectionCondition5", selectionCondition5 )
    , ( "bindScales1", bindScales1 )
    , ( "bindScales2", bindScales2 )
    ]



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
