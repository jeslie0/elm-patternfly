module Components.Accordion exposing
    ( Builder, default
    , ListType(..), withListType
    , withClassName
    , DisplaySize(..), withDisplaySize
    , HeadingLevel(..), withHeadingLevel
    , withBorder
    , toHtml
    )

{-| An **accordion** is an interactive container that expands and
collapses to hide or reveal nested content. It takes advantage of
progressive disclosure to help reduce page scrolling, by allowing
users to choose whether they want to show or hide more detailed
information as needed.

This is based on the React-Patternfly accordian. For more information,
see [here](https://www.patternfly.org/v4/components/accordion).


# Accordions


## Builder

@docs Builder, default


## List type

@docs ListType, withListType


## Class name

@docs withClassName


## Display size

@docs DisplaySize, withDisplaySize


## Heading level

@docs HeadingLevel, withHeadingLevel


## Borders

@docs withBorder


# To HTML

@docs toHtml

-}

import Html as H exposing (Attribute, Html)
import Html.Attributes exposing (attribute, class, classList, disabled, type_)


{-| Opaque builder type used to build a pipeline around.
-}
type Builder msg
    = Builder Options


type alias Options =
    { className : Maybe String
    , listType : ListType
    , displaySize : DisplaySize
    , headingLevel : HeadingLevel
    , isBordered : Bool
    }


defaultOptions : Options
defaultOptions =
    { className = Nothing
    , listType = Div
    , displaySize = Default
    , headingLevel = H3
    , isBordered = False
    }


{-| The default accordion builder. This should be the start of a
builder pipeline.
-}
default : Builder msg
default =
    Builder defaultOptions



-- * List Type


{-| The list type - either a `DefinitionList` or a `Div`. Information
about definition lists can be found [here](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dl).
-}
type ListType
    = DefinitionList
    | Div


{-| An accordion can be based off either a Definition List, or a
Div. Use the `withListType` to pass in the desired type.
-}
withListType : ListType -> Builder msg -> Builder msg
withListType listType (Builder opts) =
    Builder { opts | listType = listType }



-- * Classname


{-| The button can be given a custom class name by passing in a className
string.
-}
withClassName : Maybe String -> Builder msg -> Builder msg
withClassName mString (Builder opts) =
    Builder { opts | className = mString }



-- * Display size


{-| Display size variant.
-}
type DisplaySize
    = Default
    | Large


{-| Pipeline builder for display size.
-}
withDisplaySize : DisplaySize -> Builder msg -> Builder msg
withDisplaySize disp (Builder opts) =
    Builder { opts | displaySize = disp }



-- * Heading level


{-| Each heading level corresponds to a HTML heading level.
-}
type HeadingLevel
    = H1
    | H2
    | H3
    | H4
    | H5
    | H6


{-| Pipeline builder for the heading level.
-}
withHeadingLevel : HeadingLevel -> Builder msg -> Builder msg
withHeadingLevel level (Builder opts) =
    Builder { opts | headingLevel = level }


headingLevelToComponent : HeadingLevel -> List (Html msg) -> Html msg
headingLevelToComponent level =
    case level of
        H1 ->
            H.h1 []

        H2 ->
            H.h2 []

        H3 ->
            H.h3 []

        H4 ->
            H.h4 []

        H5 ->
            H.h5 []

        H6 ->
            H.h6 []



-- * Borders


{-| Pipeline builder to indicate if the accordion has a border.
-}
withBorder : Bool -> Builder msg -> Builder msg
withBorder bool (Builder opts) =
    Builder { opts | isBordered = bool }



-- * To HTML


type alias AccordionComponent msg =
    { mainHtml : List (Attribute msg) -> List (Html msg) -> Html msg
    , childHtml : List (Attribute msg) -> List (Html msg) -> Html msg
    }


toComponent : Builder msg -> AccordionComponent msg
toComponent (Builder opts) =
    case opts.listType of
        Div ->
            { mainHtml = H.div, childHtml = H.div }

        DefinitionList ->
            { mainHtml = H.dl, childHtml = H.dt }


toClasses : Builder msg -> List ( String, Bool )
toClasses (Builder opts) =
    let
        accordion =
            ( "pf-c-accordion", True )

        isBordered =
            if opts.isBordered then
                ( "pf-m-bordered", True )

            else
                ( "", False )

        size = case opts.displaySize of
                   Default -> ("", False)
                   Large -> ("pf-m-display-lg", True)

        className =
            case opts.className of
                Just name ->
                    ( name, True )

                Nothing ->
                    ( "", False )
    in
    [ accordion, isBordered, size, className]



{-| This function turns a Builder into a HTML component. Put this at
the end of your pipeline to get a useable accordion.
-}
toHtml : Builder msg -> List (Attribute msg) -> List (Html msg) -> Html msg
toHtml ((Builder opts) as builder) =
    \attributes children ->
        let
            components =
                toComponent builder

            mainComponent =
                components.mainHtml

            childComponent =
                components.childHtml

            updatedChildren =
                case opts.listType of
                    Div ->
                        List.map (\child -> headingLevelToComponent opts.headingLevel [ child ]) children

                    DefinitionList ->
                        List.map (\child -> childComponent [] [ child ]) children
        in
        mainComponent
            (attributes ++ [ classList <| toClasses builder ])
            updatedChildren
