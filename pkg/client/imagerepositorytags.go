package client

import (
	"fmt"

	"github.com/openshift/origin/pkg/image/api"
)

// ImageRepositoryTagsNamespacer has methods to work with ImageRepositoryTag resources in a namespace
type ImageRepositoryTagsNamespacer interface {
	ImageRepositoryTags(namespace string) ImageRepositoryTagInterface
}

// ImageRepositoryTagInterface exposes methods on ImageRepositoryTag resources.
type ImageRepositoryTagInterface interface {
	Get(name, tag string) (*api.Image, error)
}

// imageRepositoryTags implements ImageRepositoryTagsNamespacer interface
type imageRepositoryTags struct {
	r  *Client
	ns string
}

// newImageRepositoryTags returns an imageRepositoryTags
func newImageRepositoryTags(c *Client, namespace string) *imageRepositoryTags {
	return &imageRepositoryTags{
		r:  c,
		ns: namespace,
	}
}

// Get finds the specified image by name of an image repository and tag.
func (c *imageRepositoryTags) Get(name, tag string) (result *api.Image, err error) {
	result = &api.Image{}
	err = c.r.Get().Namespace(c.ns).Path("imageRepositoryTags").Path(fmt.Sprintf("%s:%s", name, tag)).Do().Into(result)
	return
}
