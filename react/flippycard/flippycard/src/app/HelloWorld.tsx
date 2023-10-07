// Import React dependencies.
import React, { useState } from 'react'
// Import the Slate editor factory.
import { createEditor } from 'slate'
import { ReactEditor } from 'slate-react'
// Import the Slate components and React plugin.
import { Slate, Editable, withReact } from 'slate-react'
import { BaseEditor, Descendant } from 'slate'

type CustomElement = { type: 'paragraph'; children: CustomText[] }
type CustomText = { text: string }

declare module 'slate' {
  interface CustomTypes {
    Editor: BaseEditor & ReactEditor
    Element: CustomElement
    Text: CustomText
  }
}

const initialValue = [
    {
      type: 'paragraph',
      children: [{ text: 'A line of text in a paragraph.' }],
    },
  ]

const RichTextExample = () => {
    // Create a Slate editor object that won't change across renders.
    const [editor] = useState(() => withReact(createEditor()))
    return <Slate editor={editor} initialValue={initialValue} />
}