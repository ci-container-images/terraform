terraform {
  version = "0.12.24"
}
providers {
    null = {
     versions = ["2.1.0"]
    }

    minio = {
      versions = ["1.1.0"]
      source = "github.com/aminuez/minio/1.1.0/linux_amd64/"
  }
  }

