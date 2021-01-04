import javascript

class FileSystemWriteAccessParameter extends DataFlow::Node {
  FileSystemWriteAccessParameter() {
    exists(FileSystemWriteAccess fswa | fswa.getAPathArgument() = this)
  }
}
