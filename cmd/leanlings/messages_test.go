package main

import (
	"reflect"
	"regexp"
	"slices"
	"testing"
)

var verb = regexp.MustCompile(`%[-+# 0]*[0-9]*(?:\.[0-9]+)?[a-zA-Z%]`)

// Every message in every language must be non-empty and use the same fmt verbs, in the same order, as en.
// Otherwise Sprintf produces garbage such as %!d(string=...).
func TestCatalogsComplete(t *testing.T) {
	base := reflect.ValueOf(*catalogs[baseLang])
	for lang, cat := range catalogs {
		v := reflect.ValueOf(*cat)
		for i := range v.NumField() {
			name := v.Type().Field(i).Name
			got, want := v.Field(i).String(), base.Field(i).String()
			if got == "" {
				t.Errorf("%s.%s is empty", lang, name)
			}
			if g, w := verb.FindAllString(got, -1), verb.FindAllString(want, -1); !slices.Equal(g, w) {
				t.Errorf("%s.%s has verbs %v, %s has %v", lang, name, g, baseLang, w)
			}
		}
	}
}

func TestHintFallback(t *testing.T) {
	h := L{"en": "hello", "ko": "안녕"}
	if h.in("ko") != "안녕" || h.in("ja") != "hello" || (L{"en": "x"}).in("ko") != "x" {
		t.Error("L.in does not fall back to en")
	}
}
