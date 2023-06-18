module Icons.AngleRight exposing (angleRight)

import Svg exposing (Svg, path, svg)
import Svg.Attributes exposing (d, fill, height, style, width, viewBox)
import Html.Attributes exposing (attribute)


angleRight : Svg msg
angleRight =
    svg
        [ style "vertical-align: -0.125em", fill "currentColor", width "1em", height "1em", viewBox "0 0 256 512", attribute "role" "img"]
        [ path [ d "M224.3 273l-136 136c-9.4 9.4-24.6 9.4-33.9 0l-22.6-22.6c-9.4-9.4-9.4-24.6 0-33.9l96.4-96.4-96.4-96.4c-9.4-9.4-9.4-24.6 0-33.9L54.3 103c9.4-9.4 24.6-9.4 33.9 0l136 136c9.5 9.4 9.5 24.6.1 34z" ] [] ]
