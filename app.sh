CFLAGS="${CFLAGS:-} -ffunction-sections -fdata-sections"
LDFLAGS="${LDFLAGS:-} -L${DEPS}/lib -Wl,--gc-sections"

### NCURSES ###
_build_ncurses() {
local VERSION="5.9"
local FOLDER="ncurses-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://ftp.gnu.org/gnu/ncurses/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
./configure --host="${HOST}" --prefix="${DEPS}" \
  --without-shared
make
make install
popd
}

### PROCPS ###
_build_procps() {
local VERSION="3.2.8"
local FOLDER="procps-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://procps.sourceforge.net/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
make install DESTDIR="${DEST}" SHARED=0 \
  CPPFLAGS="${CPPFLAGS} -I${DEPS}/include/ncurses" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
  install="install -D" \
  man1="${DEST}/man/man1/" man5="${DEST}/man/man5/" man8="${DEST}/man/man8/"
chmod -v ug+w \
  "${DEST}/bin/"* "${DEST}/sbin/"* "${DEST}/usr/bin/"*
"${STRIP}" -s -R .comment -R .note -R .note.ABI-tag \
  "${DEST}/bin/"* "${DEST}/sbin/"* "${DEST}/usr/bin/"*
popd
}

### ROOTFS ###
_build_rootfs() {
# /bin/ps
  return 0
}

### BUILD ###
_build() {
  _build_ncurses
  _build_procps
  _package
}
