module Components.Accordion.Content exposing
    ( Builder, default
    , withClassName
    , withComponent
    , withCustomContent
    , withFixed
    , withHidden
    , withAttribute, setAttributes
    , withChild, setChildren
    , withHeadingLevel, toHtml
    )

{-| The content of an Accordion Item.


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


# Attributes

@docs withAttribute, setAttributes


# Children

@docs withChild, setChildren


# Internal

@docs withHeadingLevel, toHtml

-}

import Components.Accordion.Types exposing (HeadingLevel(..))
import Html as H exposing (Attribute, Html, div)
import Html.Attributes exposing (attribute, classList)


{-| Opaque Builder type used to build a pipeline around.
-}
type Builder msg
    = Builder (Options msg)


type alias Options msg =
    { className : Maybe String
    , component : List (Attribute msg) -> List (Html msg) -> Html msg
    , isCustomContent : Bool
    , isFixed : Bool
    , isHidden : Bool
    , headingLevel : HeadingLevel
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
    , headingLevel = DefinitionList
    , children = []
    , attributes = []
    }


{-| The default Accordion Content Builder. This should be the start of a
builder pipeline.
-}
default : Builder msg
default =
    Builder defaultOptions



-- * Classname


{-| The Accordion Content can be given a custom class name by passing in a className
string.
-}
withClassName : String -> Builder msg -> Builder msg
withClassName string (Builder opts) =
    Builder { opts | className = Just string }



-- * Custom component


{-| Component to use as Accordion Content's HTML element.
-}
withComponent : (List (Attribute msg) -> List (Html msg) -> Html msg) -> Builder msg -> Builder msg
withComponent comp (Builder opts) =
    Builder { opts | component = comp }



-- * Custom content


{-| Flag to indicate the content is custom. Expanded content Body
wrapper will be removed from children. This allows multiple bodies to
be rendered as content
-}
withCustomContent : Bool -> Builder msg -> Builder msg
withCustomContent bool (Builder opts) =
    Builder { opts | isCustomContent = bool }



-- * Fixed


{-| Flag to indicate Accordion Content is fixed.
-}
withFixed : Bool -> Builder msg -> Builder msg
withFixed bool (Builder opts) =
    Builder { opts | isFixed = bool }



-- * Hidden


{-| Flag to show if the expanded content of the Accordion Item is
hidden or not. This boolean should generally be the negation of the
Accordion Toggle's `withExpanded` boolean.

-}
withHidden : Bool -> Builder msg -> Builder msg
withHidden bool (Builder opts) =
    Builder { opts | isHidden = bool }


{-| Change the heading level type of the given Builder. You shouldn't
need to ever call this when making an Accordion - the Accordion's
`toHtml` function will set the heading level of all of it's HTML
elements appropriately.
-}
withHeadingLevel : HeadingLevel -> Builder msg -> Builder msg
withHeadingLevel level (Builder opts) =
    Builder { opts | headingLevel = level }



-- * Children


{-| Add a single child HTML element to the Accordion Content's children.
-}
withChild : Html msg -> Builder msg -> Builder msg
withChild html (Builder opts) =
    Builder { opts | children = html :: opts.children }


{-| Give a list of HTML elements and set them as the children of this
Accordion Content.
-}
setChildren : List (Html msg) -> Builder msg -> Builder msg
setChildren htmls (Builder opts) =
    Builder { opts | children = htmls }



-- * Attributes


{-| Pass an attribute to the Accordion Content.
-}
withAttribute : Attribute msg -> Builder msg -> Builder msg
withAttribute attr (Builder opts) =
    Builder { opts | attributes = attr :: opts.attributes }


{-| Set the attributes of the Accordion Content to be the given list
of attributes.
-}
setAttributes : List (Attribute msg) -> Builder msg -> Builder msg
setAttributes attrs (Builder opts) =
    Builder { opts | attributes = attrs }



-- * To HTML


toClasses : Builder msg -> List ( String, Bool )
toClasses (Builder _) =
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


toWrapperAttributes : Builder msg -> List (Attribute msg)
toWrapperAttributes (Builder opts) =
    let
        hidden =
            if opts.isHidden then
                [ attribute "hidden" "" ]

            else
                []
    in
    hidden


{-| This function turns a Builder into a HTML element. This shouldn't
be used if you are constructing an Accordion Builder.
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

        wrapper =
            case opts.headingLevel of
                DefinitionList ->
                    H.dd ((classList <| toWrapperClasses builder) :: toWrapperAttributes builder)

                _ ->
                    H.div ((classList <| toWrapperClasses builder) :: toWrapperAttributes builder)
    in
    wrapper [ component (attributes ++ [ classes ]) opts.children ]
