#! /bin/bash

SIMPLE_TYPES='byte float32 float64 int int16 int32 int64 int8 rune string uint uint16 uint32 uint64 uint8 uintptr'

function ucfirst() {
    perl -ne 'print ucfirst()' <<<"$1"
}

# print simple types
for i in $SIMPLE_TYPES; do
    VAR_NAME=`ucfirst $i`
    cat <<EOF
    ${VAR_NAME} GreaterThanFunc = func (lhs, rhs interface{}) bool {
        return lhs.($i) > rhs.($i)
    }
    ${VAR_NAME}Ascending = ${VAR_NAME}
    ${VAR_NAME}Asc = ${VAR_NAME}
    ${VAR_NAME}Descending LessThanFunc = func (lhs, rhs interface{}) bool {
        return lhs.($i) < rhs.($i)
    }
    ${VAR_NAME}Desc LessThanFunc = ${VAR_NAME}Descending

EOF
done

# special case for bytes
cat <<EOF
    // the type []byte.
    Bytes GreaterThanFunc = func (lhs, rhs interface{}) bool {
        return bytes.Compare(lhs.([]byte), rhs.([]byte)) > 0
    }
    BytesAscending = Bytes
    BytesAsc = Bytes
    // the type []byte. reversed order.
    BytesDescending LessThanFunc = func (lhs, rhs interface{}) bool {
        return bytes.Compare(lhs.([]byte), rhs.([]byte)) < 0
    }
    BytesDesc LessThanFunc = BytesDescending
EOF
