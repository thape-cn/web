document.querySelectorAll("[data-admin-upload]").forEach(upload => {
  const input = upload.querySelector("[data-admin-upload-input]")
  const current = upload.querySelector("[data-admin-upload-current]")
  const pending = upload.querySelector("[data-admin-upload-pending]")
  const preview = upload.querySelector("[data-admin-upload-preview]")
  const filename = upload.querySelector("[data-admin-upload-filename]")
  const status = upload.querySelector("[data-admin-upload-status]")
  let previewURL

  const releasePreview = () => {
    if (previewURL) URL.revokeObjectURL(previewURL)
    previewURL = null
    preview.hidden = true
    preview.removeAttribute("src")
  }

  input.addEventListener("change", () => {
    releasePreview()
    const file = input.files[0]
    current.hidden = !!file
    pending.hidden = !file
    status.textContent = file ? `已选择 ${file.name}，保存后生效。` : "已取消选择。"
    if (!file) return

    filename.textContent = file.name
    if (/^image\/(jpeg|png|gif|webp)$/.test(file.type)) {
      previewURL = URL.createObjectURL(file)
      preview.src = previewURL
      preview.hidden = false
    }
  })

  preview.addEventListener("error", () => { preview.hidden = true })
  upload.querySelector("[data-admin-upload-reset]").addEventListener("click", () => {
    input.value = ""
    input.dispatchEvent(new Event("change"))
    input.focus()
  })
  window.addEventListener("pagehide", releasePreview)
  window.addEventListener("pageshow", event => {
    if (event.persisted) input.dispatchEvent(new Event("change"))
  })
})
