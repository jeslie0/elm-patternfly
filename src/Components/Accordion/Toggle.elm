module Components.Accordion.Toggle exposing (Builder, default, setChildren, toHtml, withChild, withClassName, withComponent, withExpanded, withAttribute, setAttributes)

import Components.Accordion.Types exposing (ListType(..))
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
    , listType : ListType
    , children : List (Html msg)
    , attributes : List (Attribute msg)
    }


defaultOptions : String -> Options msg
defaultOptions id =
    { className = Nothing
    , id = id
    , component = button
    , isExpanded = False
    , listType = DefinitionList
    , children = []
    , attributes = []
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



-- * Children


withChild : Html msg -> Builder msg -> Builder msg
withChild html (Builder opts) =
    Builder { opts | children = html :: opts.children }


setChildren : List (Html msg) -> Builder msg -> Builder msg
setChildren htmls (Builder opts) =
    Builder { opts | children = htmls }



-- * Attributes


withAttribute : Attribute msg -> Builder msg -> Builder msg
withAttribute attr (Builder opts) =
    Builder { opts | attributes = attr :: opts.attributes }


setAttributes : List (Attribute msg) -> Builder msg -> Builder msg
setAttributes attrs (Builder opts) =
    Builder { opts | attributes = attrs }



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


toHtml : Builder msg -> Html msg
toHtml ((Builder opts) as builder) =
    let
        attributes =
            opts.attributes

        component =
            opts.component

        classes =
            classList <| toClasses builder

        attrs =
            toAttributes

        updatedChildren =
            [ H.span [ class "pf-c-accordion__toggle-text" ] opts.children
            , H.span [ class "pf-c-accordion__toggle-icon" ] []
            ]

        wrapper =
            case opts.listType of
                DefinitionList ->
                    H.dt []

                Div ->
                    H.h3 []
    in
    wrapper [ component (attributes ++ classes :: attrs) updatedChildren ]
