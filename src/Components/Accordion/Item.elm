module Components.Accordion.Item exposing
    ( Builder
    , default
    , toHtml
    , withContent
    , withToggle
    )

{-| For use as children of accordions.


# Accordion item

@docs accordionItem

-}

import Components.Accordion.Content as AccordionContent
import Components.Accordion.Toggle as AccordionToggle
import Html exposing (Attribute, Html, div)


type Builder msg
    = Builder (Options msg)


type alias Options msg =
    { toggle : AccordionToggle.Builder msg
    , content : AccordionContent.Builder msg
    }


defaultOptions : String -> Options msg
defaultOptions id =
    { toggle = AccordionToggle.default id
    , content = AccordionContent.default
    }


default : String -> Builder msg
default id =
    Builder (defaultOptions id)


withToggle : AccordionToggle.Builder msg -> Builder msg -> Builder msg
withToggle toggle (Builder opts) =
    Builder { opts | toggle = toggle }


withContent : AccordionContent.Builder msg -> Builder msg -> Builder msg
withContent content (Builder opts) =
    Builder { opts | content = content }


toHtml : Builder msg -> List (Html msg)
toHtml (Builder opts) =
    [ AccordionToggle.toHtml opts.toggle
    , AccordionContent.toHtml opts.content
    ]
