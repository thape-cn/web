import $ from "jquery"
import Simditor from "simditor"

// Imported only by the admin pack; the public site does not load jQuery.
document.querySelectorAll("textarea[data-admin-rich-text]").forEach(textarea => {
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content
  const csrfParam = document.querySelector('meta[name="csrf-param"]')?.content
  const editor = new Simditor({
    textarea: $(textarea),
    toolbar: ["bold", "italic", "fontScale", "color", "|", "ol", "ul", "|", "image", "link", "|", "indent", "outdent", "alignment", "|", "hr", "table"],
    toolbarFloat: true,
    toolbarFloatOffset: 72,
    tabIndent: false,
    defaultImage: "data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs=",
    upload: {
      url: textarea.dataset.uploadUrl,
      fileKey: "upload_file",
      params: csrfToken && csrfParam ? { [csrfParam]: csrfToken } : {}
    }
  })

  editor.body.attr({ role: "textbox", "aria-multiline": "true", tabindex: "0" })
  const label = textarea.labels[0]
  if (label) {
    label.id ||= `${textarea.id}_label`
    editor.body.attr("aria-labelledby", label.id)
    label.addEventListener("click", () => editor.focus())
  }

  // Flush even when Save is clicked before Simditor's change debounce runs.
  textarea.form.addEventListener("submit", () => editor.sync())
})
