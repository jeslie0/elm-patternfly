module Components.Accordion.Item exposing
    ( Builder, default
    , withToggle
    , withContent
    , withHeadingLevel, toHtml
    )

{-| For use in Accordions. An Accordion Item can take two pieces of
data, an Accordion Toggle and an Accordion Content.


# Builder

@docs Builder, default


# Accordion Toggle

@docs withToggle


# Accordion Content

@docs withContent


# Internal

These functions are exposed in case they need to be used. When
building a full Accordion HTML element, you do not need to worry about
using the following functions. You only need to use them if you are
not using the Accordion's `toHtml` function.

@docs withHeadingLevel, toHtml

-}

import Components.Accordion.Content as AccordionContent
import Components.Accordion.Toggle as AccordionToggle
import Components.Accordion.Types exposing (HeadingLevel(..))
import Html exposing (Html)


{-| Opaque Builder type used to build a pipeline around.
-}
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


{-| The default Accordion Item Builder. This should be the start of a
builder pipeline.
-}
default : Builder msg
default =
    Builder defaultOptions


{-| Use the given Accordion Toggle Builder in this Accordion Item.
-}
withToggle : AccordionToggle.Builder msg -> Builder msg -> Builder msg
withToggle toggle (Builder opts) =
    Builder { opts | toggle = Just toggle }


{-| Use the given Accordion Content Builder in this Accordion Item.
-}
withContent : AccordionContent.Builder msg -> Builder msg -> Builder msg
withContent content (Builder opts) =
    Builder { opts | content = Just content }


{-| Change the heading level type of the given builder. You shouldn't
need to ever call this when making an Accordion - the Accordion's
`toHtml` function will set the heading level of all of it's HTML
elements appropriately.
-}
withHeadingLevel : HeadingLevel -> Builder msg -> Builder msg
withHeadingLevel level (Builder opts) =
    Builder
        { opts
            | toggle = Maybe.map (\toggle -> AccordionToggle.withHeadingLevel level toggle) opts.toggle
            , content = Maybe.map (\content -> AccordionContent.withHeadingLevel level content) opts.content
        }


{-| Render the given Accordion Content Builder to HTML. You don't need
to use this if you are rendering an Accordion - you only need to use
the Accordion's toHtml function.
-}
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
