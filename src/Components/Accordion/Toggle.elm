module Components.Accordion.Toggle exposing (Builder, default, toHtml, withClassName, withComponent, withExpanded)

import Html as H exposing (Attribute, Html, button)
import Html.Attributes exposing (attribute, class, classList, disabled, type_)


{-| Opaque builder type used to build a pipeline around.
-}
type Builder msg
    = Builder (Options msg)


type alias Options msg =
    { className : Maybe String
    , id : String
    , component :
        List (Attribute msg)
        -> List (Html msg)
        -> Html msg
    , isExpanded : Bool
    }


defaultOptions : String -> Options msg
defaultOptions id =
    { className = Nothing
    , id = id
    , component = button
    , isExpanded = False
    }


{-| The default accordion builder. This should be the start of a
builder pipeline. An identifier string is required for a toggle.
-}
default : String -> Builder msg
default id =
    Builder <| defaultOptions id



-- * Classname


{-| The accordion content can be given a custom class name by passing in a className
string.
-}
withClassName : Maybe String -> Builder msg -> Builder msg
withClassName mString (Builder opts) =
    Builder { opts | className = mString }



-- * Custom component


{-| Component to use as content container.
-}
withComponent : (List (Attribute msg) -> List (Html msg) -> Html msg) -> Builder msg -> Builder msg
withComponent comp (Builder opts) =
    Builder { opts | component = comp }



-- * Is Expanded


withExpanded : Bool -> Builder msg -> Builder msg
withExpanded bool (Builder opts) =
    Builder { opts | isExpanded = bool }



-- * To HTML


toClasses : Builder msg -> List ( String, Bool )
toClasses (Builder opts) =
    let
        toggle =
            ( "pf-c-accordion__toggle", True )

        expanded =
            ( "pf-m-expanded", opts.isExpanded )
    in
    [ toggle, expanded ]


toAttributes : List (Attribute msg)
toAttributes =
    [ type_ "button" ]


toHtml : Builder msg -> List (Attribute msg) -> List (Html msg) -> Html msg
toHtml ((Builder opts) as builder) =
    \attributes children ->
        let
            component =
                opts.component

            classes =
                classList <| toClasses builder

            attrs =
                toAttributes

            updatedChildren =
                [ H.span [ class "pf-c-accordion__toggle-text" ] children
                , H.span [ class "pf-c-accordion__toggle-icon" ] []
                ]
        in
        component (attributes ++ classes :: attrs) updatedChildren
