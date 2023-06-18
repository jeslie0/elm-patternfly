module Components.Accordion.Item exposing
    ( Builder
    , Options
    , default
    , toHtml
    , withContent
    , withHeadingLevel
    , withToggle
    )

{-| For use as children of accordions.


# Accordion item

@docs accordionItem

-}

import Components.Accordion.Content as AccordionContent
import Components.Accordion.Toggle as AccordionToggle
import Components.Accordion.Types exposing (HeadingLevel(..))
import Html exposing (Html)


type Builder msg
    = Builder (Options msg)


type alias Options msg =
    { toggle : Maybe (AccordionToggle.Builder msg)
    , content : Maybe (AccordionContent.Builder msg)
    , contentUnfoldsBelow : Bool
    }


defaultOptions : Options msg
defaultOptions =
    { toggle = Nothing
    , content = Nothing
    , contentUnfoldsBelow = True
    }


default : Builder msg
default =
    Builder defaultOptions


withToggle : (AccordionToggle.Builder msg) -> Builder msg -> Builder msg
withToggle toggle (Builder opts) =
    Builder { opts | toggle = Just toggle }


withContent : (AccordionContent.Builder msg) -> Builder msg -> Builder msg
withContent content (Builder opts) =
    Builder { opts | content = Just content }


withHeadingLevel : HeadingLevel -> Builder msg -> Builder msg
withHeadingLevel level (Builder opts) =
    Builder
        { opts
            | toggle = Maybe.map (\toggle -> AccordionToggle.withHeadingLevel level toggle) opts.toggle
            , content = Maybe.map (\content -> AccordionContent.withHeadingLevel level content) opts.content
        }


toHtml : Builder msg -> List (Html msg)
toHtml (Builder opts) =
    let
        toggle =
            case opts.toggle of
                Just builder ->
                    [ AccordionToggle.toHtml builder ]

                Nothing ->
                    []

        content =
            case opts.content of
                Just builder ->
                    [ AccordionContent.toHtml builder ]

                Nothing ->
                    []
    in
    if opts.contentUnfoldsBelow then
        toggle ++ content

    else
        content ++ toggle
