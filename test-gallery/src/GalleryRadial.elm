port module GalleryRadial exposing (elmToJS)

import Dict exposing (Dict)
import Platform
import VegaLite exposing (..)



-- NOTE: All data sources in these examples originally provided at
-- https://github.com/vega/vega-datasets
-- The examples themselves reproduce those at https://vega.github.io/vega-lite/examples/


radial : String -> Float -> Spec
radial dText innerR =
    let
        des =
            description dText

        cfg =
            configure
                << configuration (coView [ vicoStroke Nothing ])

        data =
            dataFromColumns []
                << dataColumn "category" (strs [ "A", "B", "C", "D", "E", "F" ])
                << dataColumn "value" (nums [ 4, 6, 10, 3, 7, 8 ])

        enc =
            encoding
                << position Theta [ pName "value", pQuant ]
                << color [ mName "category", mNominal ]
    in
    toVegaLite [ des, cfg [], data [], enc [], arc [ maInnerRadius innerR ] ]


radial1 : Spec
radial1 =
    radial "A pie chart." 0


radial2 : Spec
radial2 =
    radial "A donut chart" 50


radial3 : Spec
radial3 =
    let
        des =
            description "Pie chart with labels"

        cfg =
            configure
                << configuration (coView [ vicoStroke Nothing ])

        data =
            dataFromColumns []
                << dataColumn "category" (strs [ "A", "B", "C", "D", "E", "F" ])
                << dataColumn "value" (nums [ 4, 6, 10, 3, 7, 8 ])

        enc =
            encoding
                << position Theta [ pName "value", pQuant, pStack stZero ]
                << color [ mName "category", mNominal, mLegend [] ]

        pieSpec =
            asSpec [ arc [ maOuterRadius 80 ] ]

        labelEnc =
            encoding
                << text [ tName "category", tNominal ]

        labelSpec =
            asSpec [ labelEnc [], textMark [ maRadius 90 ] ]
    in
    toVegaLite [ des, cfg [], data [], enc [], layer [ pieSpec, labelSpec ] ]


radial4 : Spec
radial4 =
    let
        des =
            description "Radial plot with labels"

        cfg =
            configure
                << configuration (coView [ vicoStroke Nothing ])

        data =
            dataFromColumns []
                << dataColumn "strength" (nums [ 12, 23, 47, 6, 52, 19 ])

        enc =
            encoding
                << position Theta [ pName "strength", pQuant, pStack stZero ]
                << position R
                    [ pName "strength"
                    , pQuant
                    , pScale [ scZero True, scType scSqrt, scRange (raNums [ 20, 100 ]) ]
                    ]
                << color [ mName "strength", mNominal, mLegend [] ]

        segSpec =
            asSpec [ arc [ maInnerRadius 20, maStroke "white" ] ]

        labelEnc =
            encoding
                << text [ tName "strength", tQuant ]

        labelSpec =
            asSpec [ labelEnc [], textMark [ maRadiusOffset 10 ] ]
    in
    toVegaLite [ des, cfg [], data [], enc [], layer [ segSpec, labelSpec ] ]


radial5 : Spec
radial5 =
    let
        des =
            description "Reproduction of http://robslink.com/SAS/democd91/pyramid_pie.htm"

        cfg =
            configure
                << configuration (coView [ vicoStroke Nothing ])

        sky =
            "Sky"

        shade =
            "Shady side of a pyramid"

        sun =
            "Sunny side of a pyramid"

        data =
            dataFromColumns []
                << dataColumn "category" (strs [ sky, shade, sun ])
                << dataColumn "value" (nums [ 75, 10, 15 ])
                << dataColumn "order" (nums [ 3, 1, 2 ])

        colours =
            categoricalDomainMap
                [ ( sky, "#416D9D" )
                , ( shade, "#674028" )
                , ( sun, "#DEAC58" )
                ]

        enc =
            encoding
                << position Theta
                    [ pName "value"
                    , pQuant
                    , pScale [ scRange (raNums [ 2.356, 8.639 ]) ]
                    , pStack stZero
                    ]
                << color
                    [ mName "category"
                    , mNominal
                    , mScale colours
                    , mLegend [ leOrient loNone, leTitle "", leColumns 1, leX 200, leY 80 ]
                    ]
                << order [ oName "order", oQuant ]
    in
    toVegaLite [ des, cfg [], data [], enc [], arc [ maOuterRadius 80 ] ]


radial6 : Spec
radial6 =
    let
        cfg =
            configure
                << configuration (coView [ vicoStroke Nothing ])

        data =
            dataFromColumns []
                << dataColumn "month" (strs [ "1854/04", "1854/05", "1854/06", "1854/07", "1854/08", "1854/09", "1854/10", "1854/11", "1854/12", "1855/01", "1855/02", "1855/03" ])
                << dataColumn "disease" (nums [ 1, 12, 11, 359, 828, 788, 503, 844, 1725, 2761, 2120, 1205 ])
                << dataColumn "wounds" (nums [ 0, 0, 0, 0, 1, 81, 132, 287, 114, 83, 42, 32 ])
                << dataColumn "other" (nums [ 5, 9, 6, 23, 30, 70, 128, 106, 131, 324, 361, 172 ])

        trans =
            transform
                << foldAs [ "disease", "wounds", "other" ] "cause" "deaths"

        transLabels =
            transform
                << filter (fiExpr "datum.cause == 'disease'")
                << calculateAs "upper(monthFormat((substring(datum.month,length(datum.month)-2))-1))" "monthLabel"
                << calculateAs "max(datum.disease,150)" "labelRadius"

        colours =
            categoricalDomainMap
                [ ( "disease", "rgb(120,160,180)" )
                , ( "wounds", "rgb(255,190,180)" )
                , ( "other", "rgb(80,80,80)" )
                ]

        enc =
            encoding
                << position Theta [ pName "month", pOrdinal ]

        encSector =
            encoding
                << position R [ pName "deaths", pQuant, pScale [ scType scSqrt ], pStack stNone ]
                << order [ oName "cause", oOrdinal ]
                << color
                    [ mName "cause"
                    , mNominal
                    , mScale colours
                    , mLegend [ leTitle "", leLabelFont "Girassol", leOrient loNone, leX 80, leY 190 ]
                    ]

        specSector =
            asSpec
                [ encSector []
                , arc
                    [ maThetaOffset (degrees -90)
                    , maStroke "black"
                    , maStrokeWidth 0.2
                    , maOpacity 0.6
                    ]
                ]

        encLabels =
            encoding
                << angle [ mName "month", mOrdinal, mScale [ scRange (raNums [ -75, 255 ]) ] ]
                << position R [ pName "labelRadius", pQuant ]
                << text [ tName "monthLabel", tNominal ]

        specLabels =
            asSpec
                [ transLabels []
                , encLabels []
                , textMark [ maFont "Girassol", maThetaOffset (degrees -90), maDy -10 ]
                ]
    in
    toVegaLite
        [ cfg []
        , title "DIAGRAM of the CAUSES of MORTALITY"
            [ tiFont "Girassol"
            , tiFontSize 20
            , tiSubtitle "IN THE ARMY OF THE EAST\nAPRIL 1854 to MARCH 1855"
            , tiSubtitleFont "Girassol"
            , tiOffset -110
            ]
        , width 500
        , height 560
        , data []
        , trans []
        , enc []
        , layer [ specSector, specLabels ]
        ]



{- This list comprises the specifications to be provided to the Vega-Lite runtime. -}


mySpecs : Spec
mySpecs =
    combineSpecs
        [ ( "radial1", radial1 )
        , ( "radial2", radial2 )
        , ( "radial3", radial3 )
        , ( "radial4", radial4 )
        , ( "radial5", radial5 )
        , ( "radial6", radial6 )
        ]



{- The code below is boilerplate for creating a headless Elm module that opens
   an outgoing port to Javascript and sends the specs to it.
-}


main : Program () Spec msg
main =
    Platform.worker
        { init = always ( mySpecs, elmToJS mySpecs )
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = always Sub.none
        }


port elmToJS : Spec -> Cmd msg
