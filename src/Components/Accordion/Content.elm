module Components.Accordion.Content exposing
    ( Builder, default
    , withClassName
    , withComponent
    , withCustomContent
    , withFixed
    , withHidden
    , toHtml
    , setAttributes, setChildren, withAttribute, withChild
    )

{-| The content of an accordion item.


# Builder

@docs Builder, default


# Class name

@docs withClassName


# Component

@docs withComponent


# Custom content

@docs withCustomContent


# Fixed

@docs withFixed


# Hidden

@docs withHidden


# To HTML

@docs toHtml

-}

import Components.Accordion.Types exposing (ListType(..))
import Html as H exposing (Attribute, Html, div)
import Html.Attributes exposing (attribute, class, classList, disabled, type_)


{-| Opaque builder type used to build a pipeline around.
-}
type Builder msg
    = Builder (Options msg)


type alias Options msg =
    { className : Maybe String
    , component : List (Attribute msg) -> List (Html msg) -> Html msg
    , isCustomContent : Bool
    , isFixed : Bool
    , isHidden : Bool
    , listType : ListType
    , children : List (Html msg)
    , attributes : List (Attribute msg)
    }


defaultOptions : Options msg
defaultOptions =
    { className = Nothing
    , component = div
    , isCustomContent = False
    , isFixed = False
    , isHidden = False
    , listType = DefinitionList
    , children = []
    , attributes = []
    }


{-| The default accordion builder. This should be the start of a
builder pipeline.
-}
default : Builder msg
default =
    Builder defaultOptions



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



-- * Custom content


{-| Flag to indicate the content is custom. Expanded content Body
wrapper will be removed from children. This allows multiple bodioes to
be rendered as content
-}
withCustomContent : Bool -> Builder msg -> Builder msg
withCustomContent bool (Builder opts) =
    Builder { opts | isCustomContent = bool }



-- * Fixed


{-| Flag to indicate Accordion content is fixed.
-}
withFixed : Bool -> Builder msg -> Builder msg
withFixed bool (Builder opts) =
    Builder { opts | isFixed = bool }



-- * Hidden


{-| Flag to show if the expanded content of the Accordion item is
visible.
-}
withHidden : Bool -> Builder msg -> Builder msg
withHidden bool (Builder opts) =
    Builder { opts | isHidden = bool }



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
        classes =
            ( "pf-c-accordion__expanded-content-body", True )
    in
    [ classes ]


toWrapperClasses : Builder msg -> List ( String, Bool )
toWrapperClasses (Builder opts) =
    let
        accordionContent =
            ( "pf-c-accordion__expanded-content", True )

        fixed =
            ( "pf-m-fixed", opts.isFixed )

        expanded =
            ( "pf-m-expanded", not opts.isHidden )
    in
    [ accordionContent, expanded, fixed ]


toAttributes : Builder msg -> List (Attribute msg)
toAttributes (Builder opts) =
    let
        hidden =
            if opts.isHidden then
                [ attribute "hidden" "" ]

            else
                []
    in
    hidden


{-| This function turns a Builder into a HTML component. Put this at
the end of your pipeline to get a useable accordion content.
-}
toHtml : Builder msg -> Html msg
toHtml ((Builder opts) as builder) =
    let
        attributes =
            opts.attributes

        component =
            opts.component

        classes =
            classList <| toClasses builder

        attr =
            toAttributes builder

        wrapper =
            case opts.listType of
                DefinitionList ->
                    H.dd [ classList <| toWrapperClasses builder ]

                Div ->
                    H.div [ classList <| toWrapperClasses builder ]
    in
    wrapper [ component (attributes ++ classes :: attr) opts.children ]
