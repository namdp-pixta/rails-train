document.addEventListener("turbo:load", function () {
  document.addEventListener("change", function (event) {
    let image_upload = document.querySelector("#micropost_image");
    const size_in_mb = image_upload.files[0].size / 1024 / 1024;
    if (size_in_mb > 5) {
      alert("Max file size is 5MB");
      image_upload.value = "";
    }
  });
});
