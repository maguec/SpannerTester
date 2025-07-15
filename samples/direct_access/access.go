package main

import (
	"cloud.google.com/go/spanner"
	"context"
	"fmt"
	"github.com/alexflint/go-arg"
	"github.com/jamiealquiza/tachymeter"
  "github.com/schollz/progressbar/v3"
	"time"
)

var args struct {
	ProjectID  string `arg:"--project-id, -p, env:GCP_PROJECT"`
	InstanceID string `arg:"--instance-id, -i, env:GCP_SPANNER_INSTANCE"`
	DatabaseID string `arg:"--database-id, -d, env:GCP_SPANNER_DATABASE"`
	Count      int    `arg:"--count, -c, env:GCP_SPANNER_COUNT" default:"100"`
}

func main() {
	arg.MustParse(&args)
	ctx := context.Background()
	tach := tachymeter.New(&tachymeter.Config{Size: args.Count})
  bar := progressbar.Default(int64(args.Count))
	db := fmt.Sprintf("projects/%s/instances/%s/databases/%s", args.ProjectID, args.InstanceID, args.DatabaseID)
	client, err := spanner.NewClient(ctx, db)
	if err != nil {
		fmt.Println(err)
		return
	}

  /*
    execute a SELECT 1 to warm up the connectiono
  */

  stmt := spanner.Statement{
    SQL: "SELECT 1",
  }

  client.Single().Query(ctx, stmt)

  
	for i := 0; i < args.Count; i++ {
		startTime := time.Now()
		stmt := spanner.Statement{
			SQL: "SELECT id FROM customers WHERE id = @id",
			Params: map[string]interface{}{
				"id": i,
			},
		}
		it := client.Single().Query(ctx, stmt)
		_, err := it.Next()
		if err != nil {
			fmt.Println(err)
			return
		}
		tach.AddTime(time.Since(startTime))
    bar.Add(1)
		it.Stop() // Kill the iterator or you run out of file descriptors
	}
	defer client.Close()
	results := tach.Calc()
	fmt.Println("------------------ Latency ------------------")
	fmt.Printf(
		"Max:\t\t%s\nMin:\t\t%s\nP95:\t\t%s\nP99:\t\t%s\nP99.9:\t\t%s\n\n",
		results.Time.Max,
		results.Time.Min,
		results.Time.P95,
		results.Time.P99,
		results.Time.P999,
	)
}
