package track

import (
	"testing"

	"github.com/hongzio/speclings/internal/lings"
)

func TestCatalogsComplete(t *testing.T) {
	for _, p := range lings.CatalogProblems(catalogs) {
		t.Error(p)
	}
}
